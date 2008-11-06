package Prophet::CLI::Command::Clone;
use Moose;
extends 'Prophet::CLI::Command::Merge';

before 'run' => sub {
    my $self = shift;

    $self->set_arg( 'to' => $self->app_handle->handle->url() );

    my $source = Prophet::Replica->new(
        url       => $self->arg('from'),
        app_handle => $self->app_handle,
    );
    my $target = Prophet::Replica->new(
        url       => $self->arg('to'),
        app_handle => $self->app_handle,
    );

    if ( $target->replica_exists ) {
        die "The target replica already exists."; 
    }

    if (!$target->can_initialize ) {
        die "The replica path you specified isn't writable";
    }

    $target->initialize();
    $target->set_db_uuid($source->db_uuid);
    $target->resolution_db_handle->set_db_uuid($source->resolution_db_handle->db_uuid);
    return $target->_write_cached_upstream_replicas($self->arg('from'));

};

__PACKAGE__->meta->make_immutable;
no Moose;

1;
