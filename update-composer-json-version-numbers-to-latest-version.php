<?php
/**
 * Raise/update static version numbers in composer.json.
 *
 * First, run on the CLI: "composer outdated --direct > outdated.txt"
 *
 * Modified and improved version of: https://stackoverflow.com/a/41213692/951744
 */
$composerJson = json_decode(file_get_contents('composer.json'), true);

$listOfOutdatedPackages = file('outdated.txt');

foreach($listOfOutdatedPackages as $line) {

    $regexp = '/(?P<package>[\w-]+\/[\w-]+).*?(?P<currentVersion>[\d.]+).*?(?P<latestVersion>[\d.]+)/';
    preg_match($regexp, $line, $matches);
    $matches = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

    print_r($line);
    print_r($matches);

    if(isset($matches['package']))
    {
        $package = $matches['package'];

        $require = 'require';

        if(isset($composerJson['require-dev'][$package]))
        {
            $require = 'require-dev';
        }

        $currentVersion = $composerJson[$require][$package];

        // Parse and spit version into modifiers and version.
        $regexp2 = '/(?P<modifier>[^0-9]?)(?P<version>[0-9.]+)(?P<end_modifier>[\*\+])?/';
        preg_match($regexp2, $currentVersion, $matches2);

        print_r($currentVersion);
        print_r($matches2);

        if(isset($matches2['version'])) {
            $ver = explode('.', $matches2['version']);

            $latestVersion = explode('.', $matches['latestVersion']);

            // Match original version format/specificity
            // I.e. 2.3 => 3.5 and 2.3.1 => 3.5.2
            $newVersion = [];
            $i          = 0;
            foreach($ver as $v) {

                if(empty($v) && $v !== '0') continue;

                $newVersion[] = $latestVersion[$i++];
            }

            // Implode new version back into a string, and prepend modifier if we have one
            $newVersion = (isset($matches2['modifier']) ? $matches2['modifier'] : '') . implode('.',$newVersion);

            // Add end modifier if we have one
            if(isset($matches2['end_modifier']) && $matches2['end_modifier'] === '*') {
                $newVersion = $newVersion . '.*';
            }

        } else {
            $newVersion = '^' . $matches['latestVersion'];
        }

        if(substr($currentVersion, 0, 4) === 'dev-') {
            echo sprintf('Current version is "dev-*". Skipping.') . PHP_EOL;
            continue;
        }
        if($currentVersion === $newVersion) {
            echo sprintf('%s already latest version: %s', $package, $newVersion) . PHP_EOL;
            continue;
        }
        echo sprintf('Updating %s from %s to %s', $package, $currentVersion, $newVersion) . PHP_EOL;
        $composerJson[$require][$package] = $newVersion;
    }
}

file_put_contents('composer.json', json_encode($composerJson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

