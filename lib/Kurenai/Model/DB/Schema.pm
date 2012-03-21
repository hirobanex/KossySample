package Kurenai::Model::DB::Schema;
use Teng::Schema::Declare;
use Kurenai::Container qw/api/;

table {
    name 'page';
    pk 'id';
    columns qw(
        id
        rid
        title
        body
        created_at
        updated_at
    );

    inflate qr/.+_at/ => sub {
        api('DateTime')->inflate_datetime(+shift);
    };
    deflate qr/.+_at/ => sub {
        api('DateTime')->deflate_datetime(+shift);
    };
};

1;

