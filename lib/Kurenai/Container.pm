package Kurenai::Container;
use Object::Container::Exporter -base;
use File::Spec;
use File::Basename qw(dirname);


register_default_container_name 'obj';

register_namespace api => 'Kurenai::Model::Api';

register conf => sub {
    my $self = shift;
    my $root_dir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '../../'));
    my $config = do "$root_dir/config.pl";
};

register db => sub {
    my $self = shift;
    $self->load_class('Kurenai::Model::DB');
    Kurenai::Model::DB->new($self->get('conf')->{'Teng'});
};

register timezone => sub {
    my $self = shift;
    $self->load_class('DateTime::TimeZone');
    DateTime::TimeZone->new(name => 'Asia/Tokyo');
};

1;

