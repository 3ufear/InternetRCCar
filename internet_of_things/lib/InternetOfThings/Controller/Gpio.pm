package InternetOfThings::Controller::Gpio;

use Mojo::Base 'Mojolicious::Controller';

sub list {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

1;



