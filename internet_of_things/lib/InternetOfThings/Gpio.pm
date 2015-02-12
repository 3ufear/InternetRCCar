package InternetOfThings::Gpio;
use IO::Socket;
use Switch;
use InternetOfThings::Package::RaspberryConnections;

use Mojo::Base 'Mojolicious::Controller';

sub page {
    my $self = shift;
    # Render template "example/welcome.html.ep" with message
    $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

sub get_fps {
    my $self = shift;
    #socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    #my $host = "server";
    #my $port = 3141;
    #my $paddr = sockaddr_in($port, inet_aton($host) );
    #my $rasberry = InternetOfThings::Package::RaspberryConnections;
    #connect(SOCK, $paddr);
    #send(SOCK, "get_fps", 0);
    #my @fps_1 = <SOCK>;
    my $fps = InternetOfThings::Package::RaspberryConnections->Get_fps();
    $self->render(json => { fps => $fps });
}

sub set_fps {
    my $self = shift;
    my $set_fps = $self->param('fps');
    my $fps = InternetOfThings::Package::RaspberryConnections->Set_fps($set_fps);
    $self->render(json => {fps => $fps });
}

sub set_speed {
    my $self = shift;
    my $speed_s = $self->param('speed');
    my $speed = InternetOfThings::Package::RaspberryConnections->Set_speed($speed_s);
    $self->render(json => { speed => $speed });
}

sub btn_up {
    my $self = shift;
    my $code = $self->param('code');
    my $code = InternetOfThings::Package::RaspberryConnections->Btn_up($code);
    $self->render(json => { status => $code });

}
sub btn_down {
    my $self = shift;
    my $code = $self->param('code');
    my $code = InternetOfThings::Package::RaspberryConnections->Btn_down($code);
    $self->render(json => { status => $code });

}



1;



