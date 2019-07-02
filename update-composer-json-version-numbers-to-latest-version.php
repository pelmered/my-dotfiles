<?php
/**
 * Raise/update static version numbers in composer.json.
 *
 * First, run on the CLI: "composer outdated --direct > outdated.txt"
 *
 * Modified version of: https://stackoverflow.com/a/41213692/951744
 */
$composerJson = json_decode(file_get_contents('composer.json'), true);

$listOfOutdatedPackages = file('outdated.txt');

foreach($listOfOutdatedPackages as $line) {

    $regexp = '/(?P<package>[\w-]+\/[\w-]+).*(?P<currentVersion>\d.\d.\d).*(?P<latestVersion>\d.\d.\d)/';
    preg_match($regexp, $line, $matches);
    $matches = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

    //print_r($matches);

    if(isset($matches['package']))
    {
        $package = $matches['package'];

        $require = 'require';

        if(isset($composerJson['require-dev'][$package]))
        {
            $require = 'require-dev';
        }

        /*
        echo 'OK'.PHP_EOL;

        print_r($composerJson);
        print_r($require);

        echo '--'.PHP_EOL;
        */

        $currentVersion = $composerJson[$require][$package];


        $regexp2 = '/(?P<modifier>[^0-9]?)(?P<version>[0-9.]+)(?P<end_modifier>[\*\+])?/';
        preg_match($regexp2, $currentVersion, $matches2);

        if(isset($matches2['version'])) {
            $ver = explode('.', $matches2['version']);

            $lver = explode('.', $matches['latestVersion']);

            /*
            print_r($matches2);
            print_r($ver);
            print_r($lver);
            */

            $newver = [];
            $i = 0;
            foreach($ver as $v) {

                if(empty($v) && $v !== '0') continue;

                $newver[] = $lver[$i++];
            }
            $newver = (isset($matches2['modifier']) ? $matches2['modifier'] : '').implode('.',$newver);

            if(isset($matches2['end_modifier']) && $matches2['end_modifier'] === '*') {
                $newver = $newver.'.*';
            }

        } else {
            $newver = '^'.$matches['latestVersion'];
        }

        /*
        print_r($newver);
        print_r($package);
        print_r($currentVersion);
        print_r($matches);
        */

        if($currentVersion === $newver) {
            echo sprintf('%s already latest version: %s', $package, $newver).PHP_EOL;
            continue;
        }
        echo sprintf('Updating %s from %s to %s', $package, $currentVersion, $newver).PHP_EOL;
        $composerJson[$require][$package] = $newver;


        //echo '-----------------'.PHP_EOL;
    }

    //die();
}

file_put_contents('composer.json', json_encode($composerJson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

