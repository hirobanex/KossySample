package Kurenai::Model::Api::DateTime;
use strict;
use warnings;
use Kurenai::Container;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL;
use DateTime::Format::Mail; 
use DateTime::Format::W3CDTF;
use DateTime::Format::HTTP;

sub new { bless {}, +shift }

sub now {
    DateTime->now(time_zone => obj('timezone'));
}

sub today {
    DateTime->today(time_zone => obj('timezone'));
}

sub covert_w3c_format {
    my ($self,$datetime) = @_;

    DateTime::Format::W3CDTF->format_datetime($datetime);
}

sub covert_rfc822_format {
    my ($self,$datetime) = @_;

    DateTime::Format::Mail->format_datetime($datetime);
}

sub covert_rfc1123_format {
    my ($self,$datetime) = @_;

    DateTime::Format::HTTP->format_datetime($datetime);
}

sub strptime {
    my ($self, $str, $pattern) = @_;

    my $dt = DateTime::Format::Strptime->new(
        pattern   => $pattern,
        time_zone => obj('timezone'),
    )->parse_datetime($str);

    DateTime->from_object( object => $dt );
}

sub inflate_date {
    my ($self, $str) = @_;

    return unless $str;
    return if $str eq '0000-00-00';
    return $self->strptime($str, '%Y-%m-%d');
}

sub inflate_datetime {
    my ($self, $str) = @_;

    return unless $str;
    return if $str eq '0000-00-00 00:00:00';
    return $self->strptime($str, '%Y-%m-%d %H:%M:%S');
}

sub deflate_date {
    my ($self, $dt) = @_;

    return $dt unless ref $dt eq 'DateTime';
    DateTime::Format::MySQL->format_date($dt);
}

sub deflate_datetime {
    my ($self, $dt) = @_;

    return $dt unless ref $dt eq 'DateTime';
    DateTime::Format::MySQL->format_datetime($dt);
}

1;
