package InternetOfThings;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  
  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/gpio')->to('gpio#page');
  $r->get('/get_fps')->to('gpio#get_fps');
  $r->get('/set_fps')->to('gpio#set_fps');
  $r->get('/set_speed')->to('gpio#set_speed');
  $r->get('btn_up')->to('gpio#btn_up');
  $r->get('btn_down')->to('gpio#btn_down');
  $r->get('/')->to('example#welcome');
}

1;
