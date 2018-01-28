use strict;
use warnings;

use Irssi;

use WWW::Google::Translate;
use Lingua::JA::Moji qw/kana2romaji romaji2kana/;
use utf8;

our $wgt = WWW::Google::Translate->new(
    {   key            => 'Your API key here',
        default_source => 'en',
        default_target => 'ja',
    }
);

our $VERSION = '1.00';
our %IRSSI = (
    authors     => 'Arkos Vähämäki',
    contact     => 'rkos@far.fi',
    name        => 'Weeb.pl',
    description => 'Translates a random word in ones messages to Japanese (from English) ',
    license     => 'GPLv3.0',
);

Irssi::signal_add_first 'send text', 'my_handler';

sub my_handler {
   my ($text, $server, $win_item) = @_;
   my @words = split(/ /, $text);
   my $wordamount = @words;
   my $choice = int(rand($wordamount));
   my $r = $wgt->translate( { q => @words[$choice] } );
   my $word = kana2romaji($r->{data}->{translations}->[0]->{translatedText});
   s/@words[$choice]/$word/ for @words;
   $text = join(" ",@words);
   Irssi::signal_continue($text, $server, $win_item);
}
