package Kurenai::Web;
use strict;
use warnings;
use utf8;
use Kossy;
use Kurenai::Container qw/api/;

filter 'set_rss_header' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        my $res = $app->($self,$c);
        $res->headers([ 'Content-Type' => 'application/rss+xml' ]);
        $res;
    }
};

get '/' => sub {
    my ( $self, $c )  = @_;

    my $title = api('Page')->front 
        or return $c->redirect(
            $c->req->uri_for('/register',[title => 'FrontPage'])
        );

    $c->render('index.tx',{
        page => $title,
    });
};

get '/register' => sub {
    my ($self, $c) = @_;

    $c->render('register.tx');
};

post '/add' => sub {
    my ($self, $c) = @_;

    my $result = $c->req->validator([
        title => [['NOT_NULL','title must be defined']],
        body  => [['NOT_NULL','body must be defined']],
    ]);

    $result->has_error 
        and return $c->render('register.tx',{ validator => $result, });

    my $page = api('Page')->add(
        $c->req->parameters
    );

    return $c->redirect('/'.$page->rid);
};

get '/list' => sub {
    my ($self, $c) = @_;

    my ($list, $pager) = api('Page')->search(
        page => $c->req->param('page') || 1,
    );

    $c->render('list.tx',{
        list          => $list,
        has_next_page => $pager->has_next,
    });
};

get '/search' => sub {
    my ($self, $c) = @_;

    my $vars = +{};
    if (my $keyword = $c->req->param('keyword') ) {
        my ($list, $pager) = api('Page')->search(
            page    => $c->req->param('page') || 1,
            keyword => $keyword,
        );

        $vars = +{
            list          => $list,
            has_next_page => $pager->has_next,
        };
    }

    $c->render('list.tx',$vars);
};

get '/rss' => [qw/set_rss_header/] => sub {
    my ($self, $c) = @_;

    $c->render('rss.tx',{
        list  => (api('Page')->search)[0],
        today => api('DateTime')->today,
    });
};

router ['GET','POST'] => '/edit/:rid' => sub {
    my ($self, $c) = @_;

    my $page = api('Page')->get($c->args->{rid})
        or return $c->redirect('/');

    if ( $c->req->method eq 'POST' ) {
        my $result = $c->req->validator([
            title               => [['NOT_NULL','title must be defined']],
            current_updated_at  => [[sub {
                my ($req,$val) = @_;
                api('Page')->not_conflict($page, $val);
            },'更新が衝突しました！やりなおしてください'],
        ]]);

        $result->has_error 
            and return $c->render('register.tx',{ 
                validator => $result, 
                page      => $page,
            });

        api('Page')->edit_or_delete($page, $c->req->parameters);

        return $c->redirect('/'.$page->rid);
    }

    $c->render('register.tx',{
        page => $page,
    });
};

get '/:rid' => sub {
    my ($self, $c) = @_;

    my $page = api('Page')->get($c->args->{rid})
        or return $c->redirect('/');

    $c->render('index.tx',{
        page => $page,
    });
};

1;

