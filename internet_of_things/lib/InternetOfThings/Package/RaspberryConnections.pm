package InternetOfThings::Package::RaspberryConnections;

use strict;
use IO::Socket;


sub Get_fps {
    socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    my $host = "server";
    my $port = 3141;
    my $paddr = sockaddr_in($port, inet_aton($host) );
    connect(SOCK, $paddr);
    send(SOCK, "get_fps", 0);
    my $fps = <SOCK>;
    return $fps;
}

sub Set_fps {
    my ($class, $fps) = @_;
    socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    my $host = "server";
    my $port = 3141;
    my $paddr = sockaddr_in($port, inet_aton($host) );
    connect(SOCK, $paddr);
    send(SOCK, "set_fps $fps", 0);
    $fps = <SOCK>;
    return $fps;
}

sub Set_speed {
    my ($class, $speed) =@_;
    socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    my $host = "server";
    my $port = 3001;
    my $paddr = sockaddr_in($port, inet_aton($host) );
    connect(SOCK, $paddr);
    send(SOCK, "set_speed $speed", 0);
    $speed = <SOCK>;
    return $speed;
}

sub Btn_down {
    
    my ($class, $code) =@_;
    socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    my $host = "server";
    my $port = 3001;
    my $paddr = sockaddr_in($port, inet_aton($host) );
    connect(SOCK, $paddr);
    send(SOCK, "btn_down $code", 0);
    $code = <SOCK>;
    return $code;

}

sub Btn_up {

    my ($class, $code) =@_;
    socket(SOCK,PF_INET,SOCK_STREAM, getprotobyname('tcp'));
    my $host = "server";
    my $port = 3001;
    my $paddr = sockaddr_in($port, inet_aton($host) );
    connect(SOCK, $paddr);
    send(SOCK, "btn_up $code", 0);
    $code = <SOCK>;
    return $code;

}




1;
