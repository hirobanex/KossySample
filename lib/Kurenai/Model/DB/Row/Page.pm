package Kurenai::Model::DB::Row::Page;
use strict;
use warnings;
use parent 'Teng::Row';
use Text::Xatena;

sub formatted_body {
    my $self = shift;
    my $thx = Text::Xatena->new;
    $thx->format($self->body);
}

1;


