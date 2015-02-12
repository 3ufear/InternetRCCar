#!/usr/bin/perl -w

use strict;
use IO::Socket;
use Time::localtime;
use HiPi::Wiring qw(:wiring);
use Device::BCM2835;

my $port = 3001;
my $PIN_PWM = 1;#PWM PIN = 18

Device::BCM2835::init() || die "Could not init library";

#my $PIN  = $bcm->get_pin( RPI_V2_GPIO_P1_16 );


Device::BCM2835::gpio_fsel(RPI_V2_GPIO_P1_22, BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(RPI_V2_GPIO_P1_24, BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(RPI_V2_GPIO_P1_16, BCM2835_GPIO_FSEL_OUTP);
HiPi::Wiring::wiringPiSetup();
HiPi::Wiring::pinMode( $PIN_PWM, WPI_PWM_OUTPUT );
Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_16);
HiPi::Wiring::pwmWrite( $PIN_PWM, 0 );

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
    my $data;
    my $count = sysread(CLIENT, $data, 1024);
    print "Принято ${count} \n";
    print $data;
    my $rn = "\r\n";
    if ($data =~ /set_speed (-?\d+)/) {
        if ($1 eq '1') {
            Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_16);
            HiPi::Wiring::pwmWrite( $PIN_PWM, 1024 );
            print CLIENT 1024;
        } elsif ($1 eq '-1') {
            Device::BCM2835::gpio_set(RPI_V2_GPIO_P1_16);
            HiPi::Wiring::pwmWrite( $PIN_PWM, 0);
            print CLIENT -1024
        } else {
            Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_16);
            HiPi::Wiring::pwmWrite( $PIN_PWM, 0 );
            print CLIENT 0;
        }      
    } elsif($data =~ /btn_down (\d+)/) {
       if ($1 == 87 || $1 == 38) {
           HiPi::Wiring::pwmWrite( $PIN_PWM, 1024 );
           print CLIENT 'OK';
       } elsif ( $1 == 83 || $1 == 40) {
           Device::BCM2835::gpio_set(RPI_V2_GPIO_P1_16);
           print CLIENT 'OK';
       } elsif ( $1 == 65 || $1 == 37 ) {
           Device::BCM2835::gpio_set(RPI_V2_GPIO_P1_22);
           print 'RIGHT_TURN_ON';   

       } elsif ( $1 == 68 || $1 == 39) {
           Device::BCM2835::gpio_set(RPI_V2_GPIO_P1_24);
           print 'LEFT_TURN_ON'
       }
    } elsif($data =~ /btn_up (\d+)/) {
       if ($1 == 87 || $1 == 38) {
            HiPi::Wiring::pwmWrite( $PIN_PWM, 0 );
            print CLIENT 'OK';
       } elsif ( $1 == 83 || $1 == 40) {
            Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_16);
            print CLIENT 'OK';
       } elsif ( $1 == 65 || $1 == 37 ) {
            Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_22);
            print 'RIGHT_TURN_OFF';

       } elsif ( $1 == 68 || $1 == 39) {
           Device::BCM2835::gpio_clr(RPI_V2_GPIO_P1_24);
           print 'LEFT_TURN_OFF'
       }
    } else {
      print "Unknown command";
    }
    # Отправляем данные клиенту
    
    my $rn = "\r\n";

    # Закрываем соединение
    close(CLIENT);
}

