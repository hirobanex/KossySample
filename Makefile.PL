use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Kurenai',
    VERSION_FROM  => 'lib/Kurenai.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.07',
        'DateTime::Format::MySQL' => '0.04',
        'DateTime' => '0.72',
        'DateTime::Format::HTTP' => '0.40',
        'Smart::Args' => '0.10',
        'Text::Xatena' => '0.18',
        'Object::Container::Exporter' => '0.03',
        'DateTime::Format::Mail' => '0.3001',
        'DateTime::Format::Strptime' => '1.5000',
        'DateTime::Format::W3CDTF' => '0.06',
        'Data::GUID' => '0.046',
        'Teng' => '0.14',
        'DateTime::TimeZone' => '1.45',
    },
    MIN_PERL_VERSION => '5.008001'
);

