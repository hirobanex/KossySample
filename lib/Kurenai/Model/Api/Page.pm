package Kurenai::Model::Api::Page;
use strict;
use warnings;
use Kurenai::Container qw/api/;
use Data::GUID;
use Smart::Args;

sub new { bless {}, +shift }

sub not_conflict {
    my ($self, $page, $epoch) = @_;
    return $page->updated_at->epoch == $epoch
        ? 1
        : 0
    ;
}

sub add {
    args my $self,
         my $title,
         my $body;

    $body  =~ s/\r//g;
    obj('db')->insert('page',{
        rid        => Data::GUID->new->as_hex,
        title      => $title,
        body       => $body,
        created_at => api('DateTime')->now,
    });
}

sub edit_or_delete {
    my ($self, $page, $args) = @_;

    (my $body = $args->{body}) =~ s/\r//g;

    if ($body) {
        $page->update(
            {
                title => $args->{title},
                body  => $body,
            }
        );
    } else {
        $page->delete;
    }
}

sub get { obj('db')->single('page', {rid => $_[1]}) }

sub front { obj('db')->single('page', {title => 'FrontPage'}) }

my $LIMIT = 3;
sub search {
    args my $self,
         my $keyword => {optional => 1, isa => 'Maybe[Str]'},
         my $page    => {optional => 1, isa => 'Maybe[Defined]', default => 1 };

    my $where = ($keyword) 
        ? +{'body' => {'like' => "%$keyword%"}}
        : +{}
    ;
    my ($rows, $pager) = obj('db')->search_with_pager('page', $where, {page => $page || 1, rows => $LIMIT});

    return ($rows, $pager);
}

1;
