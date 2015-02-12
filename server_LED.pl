#!/usr/bin/perl -w

use strict;
use IO::Socket;
use Time::localtime;
use HiPi::BCM2835;

my $port = 3141;

my $previuos_sec = -20;
my $previuos_min = 0;
my $frequency = 5;
my $led_is_en = 0;

my $bcm = HiPi::BCM2835->new();
# Создаем сокет
socket(SOCK, PF_INET,SOCK_STREAM, getprotobyname('tcp')) or die ("Не могу создать сокет!");
setsockopt(SOCK, SOL_SOCKET, SO_REUSEADDR, 1);

# Связываем сокет с портом
my $paddr = sockaddr_in($port, INADDR_ANY);
bind(SOCK, $paddr) or die("Не могу привязать порт!");

# Ждем подключений клиентов
print "Ожидаем подключения...\n";
listen(SOCK, SOMAXCONN);
while (my $client_addr = accept(CLIENT, SOCK)){
    my ($asec) = (localtime)[0,1];
    my $min = $asec->[1];
    my $sec = $asec->[0];
    if ($frequency > 0) {
    if (!$led_is_en) {
        if($previuos_min == $min) {
             if ($sec-$previuos_sec > 40/$frequency) {
                 print "LED ON\n";
                 $previuos_sec = $sec;
                 $led_is_en = 1;
             }
        } else {
             if ((60 - $previuos_sec + $sec) > 40/$frequency ) {
                 print "LED ON\n";
                 $previuos_sec = $sec;
                 $previuos_min = $min;
                 $led_is_en = 1;
             }
        }
    } else {
         if($previuos_min == $min) {
             if ($sec-$previuos_sec > 1) {
                 print "LED OFF\n";
                 $previuos_sec = $sec;
                 $led_is_en = 0;
             }
        } else {
             if ((60 - $previuos_sec + $sec) > 1 ) {
                 print "LED OFF\n";
                 $previuos_sec = $sec;
                 $previuos_min = $min;
                 $led_is_en = 0;
             }
        }

    }
    }
    # Получаем адрес клиента
    my ($client_port, $client_ip) = sockaddr_in($client_addr);
    my $client_ipnum = inet_ntoa($client_ip);
    my $client_host = gethostbyaddr($client_ip, AF_INET);

    # Принимаем данные от клиента
    my $data;
    my $count = sysread(CLIENT, $data, 1024);
    #print "Принято ${count} байт от ${client_host} [${client_ipnum}]\n";
    #print $data;
    my $rn = "\r\n";
    if ($data =~ /get_fps/) {
        print CLIENT $frequency;
        print "$rn";
    } elsif ($data =~ /set_fps (\d+)/) {
        $frequency = $1;
        print CLIENT $frequency;
        print $rn;
    }
    # Отправляем данные клиенту
    
    #my $rn = "\r\n";
    #print CLIENT 'HTTP/1.1 200 Ok';
    #print CLIENT $rn;
    #print CLIENT 'X-Powered-By: Express';
    #print CLIENT $rn;
    #print CLIENT 'ETag: W/"8-f9611a42"';
    #print CLIENT $rn;
    #print CLIENT 'Date: Sun, 18 Jan 2015 17:07:44 GMT';
    #print CLIENT $rn;
    #print CLIENT 'Connection: keep-alive';
    #print CLIENT $rn;
    #print CLIENT 'Access-Control-Allow-Origin: http://192.168.137.33';
    #print CLIENT $rn;
    #print CLIENT 'Access-Control-Allow-Credentials: true';
    #print CLIENT $rn . $rn;
    #print CLIENT "Fps is 5";
    #print CLIENT $rn;

    # Закрываем соединение
    close(CLIENT);
}

