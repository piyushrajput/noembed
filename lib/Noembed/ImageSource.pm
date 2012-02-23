package Noembed::ImageSource;

use parent 'Noembed::Source';

sub post_download {
  my ($self, $body, $req, $cb) = @_;

  my $data = $self->image_data($body, $req);
  die "No image found" unless $data->{src};

  Noembed::Util::dimensions $data->{src}, $req, sub {
    my ($w, $h) = @_;
    $data->{width} = $w;
    $data->{height} = $h;
    $cb->($data);
  }
}

sub serialize {
  my ($self, $data, $req) = @_;

  return +{
    title => $data->{title} || $req->url,
    html => $self->render($data, $req->url),
  }
}

sub render {
  my $self = shift;
  $self->{render}->("ImageSource.html", @_);
}

1;

=pod

=head1 NAME

Noembed::ImageSource - a base class for image sources

=head1 DESCRIPTION

This is a subclass of L<Noembed::Source> meant for images. Sub-classes
should not define a C<serialize> method, instead defining an C<image_data>
method.

This class will automatically look for maxheight and maxwidth
parameters in the original request. If found, the image will be
scaled down to fit the requested dimensions.

=head1 METHODS

=over 4

=item image_data ($body)

This method accepts the downloaded content and must return a hashref
containing C<src> and C<title> keys. These will be used to build the final
HTML for the response.

=back

=head1 SEE ALSO

L<Noembed::Source::Instagram>, L<Noembed::Source::Imgur>,
L<Noembed::Source::Skitch>

=cut
