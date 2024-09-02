%define base_name freetype-envision
%define variation full


Name:           %{base_name}-%{variation}
Version:        0.7.0
Release:        1%{?dist}
BuildArch:      noarch
Summary:        FreeType font rendering library adjustments to improve visibility on the Linux platform, %{variation} preset

License:        BSD-2-Clause
URL:            https://github.com/maximilionus/freetype-envision

Source0:        https://github.com/maximilionus/freetype-envision/releases/download/v%{version}/%{base_name}-%{version}.tar.gz
Source1:        %{base_name}-%{version}.tar.gz

Requires:       freetype
Provides:       deprecated()
Conflicts:      %{base_name}-normal
Conflicts:      %{base_name}


%description
Carefully tuned FreeType font rendering library adjustments, designed to improve fonts visibility on Linux platform.

Full preset tries to maximize the readability of the rendering for all the font drivers and options, at the cost of severe distortions in the rendering of some elements.

This version is deprecated and will be removed on version 1.0.0 release. Please use the main 'freetype-envision' package to get all the latest features.


%prep
%setup -n %{base_name}-%{version}

%build


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_sysconfdir}/profile.d
mkdir -p %{buildroot}/%{_sysconfdir}/fonts/conf.d

# profile.d
install -m 644 profile.d/freetype-envision-%{variation}.sh %{buildroot}/%{_sysconfdir}/profile.d/freetype-envision.sh

# fontconfig
install -m 644 fontconfig/freetype-envision-grayscale.conf %{buildroot}/%{_sysconfdir}/fonts/conf.d/11-freetype-envision-grayscale.conf
install -m 644 fontconfig/freetype-envision-droid-sans.conf %{buildroot}/%{_sysconfdir}/fonts/conf.d/70-freetype-envision-droid-sans.conf


%files
%{_sysconfdir}/profile.d/freetype-envision.sh
%{_sysconfdir}/fonts/conf.d/11-freetype-envision-grayscale.conf
%{_sysconfdir}/fonts/conf.d/70-freetype-envision-droid-sans.conf


%changelog
* Fri Jul 19 2024 maximilionus <maximilionuss@gmail.com>
- Deprecate the package. Maintenance update.

* Sat Jun 29 2024 maximilionus <maximilionuss@gmail.com>
- Update to version 0.6.0

* Tue Jun 26 2024 maximilionus <maximilionuss@gmail.com>
- Update to version 0.5.0

* Thu Jun 13 2024 maximilionus <maximilionuss@gmail.com>
- Update version to 0.4.0

* Tue Jun 11 2024 maximilionus <maximilionuss@gmail.com>
- Initial package release
