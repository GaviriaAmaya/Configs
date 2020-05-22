# Update packages and dependencies
exec { 'Update':
  command => '/usr/bin/apt-get update',
}

# Clean dependencies
exec { 'Clean_packages':
  command => '/usr/bin/apt-get autoremove -y',
}

# Install standard library from Puppet
exec { 'stdlib-puppet':
  command => '/usr/bin/puppet module install puppetlabs-stdlib',
}

# Install Zsh to get OhMyZsh
package { 'zsh':
  ensure => latest,
}

# Install or update git
package { 'git':
  ensure => latest,
}

# Install emacs
package { 'emacs':
  ensure => latest,
}

package { 'puppet-lint':
  ensure   => '2.1.1',
  provider => 'gem',
}

file { '/home/vagrant/.emacs':
  ensure  => file,
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0664',
  content => '(setq c-default-style "bsd"
            c-basic-offset 8
                  tab-width 8
                        indent-tabs-mode t)
(require \'whitespace)
(setq whitespace-style \'(face empty lines-tail trailing))
(global-whitespace-mode t)
(setq column-number-mode t)
;; set background
(set-background-color "misterioso")
;; show cursor position within line
(column-number-mode 1)
;; Configure backspace
(global-set-key [(control ?h)] \'delete-backward-char)
;; set line numbers
(global-linum-mode 1) ; always show line numbers'
}

exec { 'Betty':
  command => 'usr/bin/git clone https://github.com/holbertonschool/Betty.git',
}
exec { 'Betty_Install':
  command => '/home/vagrant/Betty/install.sh',
  require => ['Betty'],
}

$theme = 'xiong-chiamiov-plus'

# Get and install OhMyZsh
exec { 'OhMyZsh':
  command => '/bin/sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"',
  require => Package['git'],
}

file_line { "${theme}-install":
  path    => '/home/vagrant/.zshrc',
  line    => "ZSH_THEME=\"${theme}\"",
  match   => '^ZSH_THEME',
  require => Exec['OhMyZsh', 'stdlib-puppet'],
}

file_line { 'gcc_alias':
  path    => '/home/vagrant/.zshrc',
  line    => 'alias gcc="gcc Wall -Werror -Wextra -pedantic"',
  require => Exec['OhMyZsh', 'stdlib-puppet'],
}

file_line { 'sudo_alias':
  path    => '/home/vagrant/.zshrc',
  line    => 'alias ins="sudo apt-get install"',
  require => Exec['OhMyZsh', 'stdlib-puppet'],
}
