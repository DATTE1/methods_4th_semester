<?php

function createFib($a, $b) {
    return function() use (&$a, &$b) {
        $test = $a + $b;
        $a = $b;
        $b = $test;
        return $test;
    };
}

function createRandom() {
    $numbers = range(0, 10);
    shuffle($numbers);
    $index = 0;
    
    return function() use (&$numbers, &$index) {
        if ($index < count($numbers)) {
            return $numbers[$index++];
        } else {
            return false;
        }
    };
}

echo "Генератор Фибоначчи (1,1):\n";
$fibA = createFib(1, 1);
for ($i = 0; $i < 5; $i++) {
    echo $fibA() . "\n";
}

echo "\nГенератор Фибоначчи (0,2):\n";
$fibB = createFib(0, 2);
for ($i = 0; $i < 5; $i++) {
    echo $fibB() . "\n";
}

echo "\nГенератор случайных уникальных чисел (0-10):\n";
$rnd = createRandom();
for ($i = 0; $i < 15; $i++) {
    $result = $rnd();
    echo ($result === false ? "false" : $result) . "\n";
}

?>
