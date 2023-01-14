@echo off
setlocal enabledelayedexpansion

:introduction
echo Hello and welcome to the monster arena.
echo I will walk you through your monster's registration.

:monsterReg
echo What is your monster's name?
set /P monster_name=

echo So your monster's name is %monster_name%? Hmm...

rem scramble stats
set /a lv = 1

call :generateRandomNumber
set /a vary = !randnum! %% 5
set /a mhp = 25 + !vary! - 2

call :generateRandomNumber
set /a vary = !randnum! %% 3
set /a atk = 10 + !vary! - 1

call :generateRandomNumber
set /a vary = !randnum! %% 3
set /a def = 10 + !vary! - 1

call :generateRandomNumber
set /a vary = !randnum! %% 3
set /a mat = 10 + !vary! - 1

call :generateRandomNumber
set /a vary = !randnum! %% 3
set /a mdf = 10 + !vary! - 1

call :generateRandomNumber
set /a vary = !randnum! %% 3
set /a spd = 10 + !vary! - 1

call :generateRandomNumber
set /a type=!randnum! %% 4

rem this is used by skills
rem secondary hp bar; magical light
set /a barrier = 0

rem extra resistance; magical water
set /a protection = 0

rem counter damage and resistance; magical fire
set /a spikes = 0

rem healing; magical grass
set /a grassUses = 0

rem type resistance; magical element, use as flag
set /a defenses = -1

if !type! ==0 (
    set flavor=cool
    rem fire
) else if !type! == 1 (
    set flavor=cute
    rem water
) else if !type! == 2 (
    set flavor=neat
    rem grass
) else (
    set flavor=fine
    rem light
)

echo That's a !flavor! name.

rem vary stats
call :generateRandomNumber
set /a statsNumber = !randnum! %% 36

set /a first_number = statsNumber %% 6
set /a second_number = statsNumber / 6

if not %first_number% == %second_number% (
    echo Your monster is kind of special.
    if first_number == 0 (
        set /a mhp= %mhp% + 5
    ) else if first_number == 1 (
        set /a atk= %atk% + 2
    ) else if first_number == 2 (
        set /a def=%def% + 2
    ) else if first_number == 3 (
        set /a mat=%mat% + 2
    ) else if first_number == 4 (
        set /a mdf=%mdf% + 2
    ) else if first_number == 5 (
        set /a spd=%spd% + 2
    )

    if second_number == 0 (
        set /a mhp= %mhp% - 3
    ) else if second_number == 1 (
        set /a atk= %atk% - 1
    ) else if second_number == 2 (
        set /a def=%def% - 1
    ) else if second_number == 3 (
        set /a mat=%mat% - 1
    ) else if second_number == 4 (
        set /a mdf=%mdf% - 1
    ) else if second_number == 5 (
        set /a spd=%spd% - 1
    )
) else (
    echo Your monster is pretty average.
)

set /a hp = %mhp%

call :generateRandomNumber
set /a move_1 = !randnum! %% 48
call :generateRandomNumber
set /a move_2 = !randnum! %% 48
call :generateRandomNumber
set /a move_3 = !randnum! %% 48
call :generateRandomNumber
set /a move_4 = !randnum! %% 48

rem moves are divided by
rem prio, normal, slow
rem fire, water, grass, light
rem magic, physical
rem offense, defense
rem and the monster has 4 of them

set /a round = 1
pause
goto :battle

:battle
cls
echo Oh no^^! A monster has appeared^^!
pause

:generateEnemy
set /a e_hp = 25
set /a e_atk = 10
set /a e_def = 10
set /a e_mat = 10
set /a e_mdf = 10
set /a e_spd = 10
set /a e_type = 0
set /a e_barrier = 0

rem this is used by skills
rem secondary hp bar; magical light
set /a e_shield = 0

rem extra resistance; magical water
set /a e_protection = 0

rem counter damage and resistance; magical fire
set /a e_spikes = 0

rem healing; magical grass
set /a e_grassUses = 0

rem type resistance; magical element, use as flag
set /a e_defenses = -1


:battleLoop
cls
echo %monster_name%'s HP: %hp%/%mhp%
echo What will you do?

:selectMove
call :showAttacks
call :selectAttack

:turnExecute
cls

set /a player_move = 
if !selected! == 0 (
    set /a player_move = !move_1!
) else if !selected! == 1 (
     set /a player_move = !move_2!
) else if !selected! == 2 (
     set /a player_move = !move_3!
) else if !selected! == 3 (
     set /a player_move = !move_4!
)

set /a _0 = !player_move!
call :getAttack
echo !monster_name! is about to use !_moveName!^^!

rem calculate your attack's modifiers
call :generateRandomNumber
set /a vary = !randnum! %% 7

if !_1! == 0 (
    rem your attack is quick
    set /a vary = !vary! + 25
) else if !_1! == 2 (
    rem your attack is slow
    set /a vary = !vary! - 10
)

rem generate a random enemy move
call :generateRandomNumber
set /a enemyAtk = !randnum! %% 48

rem calculate their attack's modifiers
set /a _0 = enemyAtk
call :getAttack
if !_1! == 0 (
    rem their attack is quick
    set /a vary = !vary! - 25
) else if !_1! == 2 (
    rem their attack is slow
    set /a vary = !vary! + 10
)

set /a _turn_spd = !spd! + !vary! - 4 - !e_spd!

if !_turn_spd! GTR 0 (
    echo You outsped!
    call :attack
    if !e_hp! LEQ 0 (
        goto :win
    ) 
    call :getAttacked
    if !hp! LEQ 0 (
        goto :lose
    ) 
) else (
    echo They got the upper hand!
    call :getAttacked
    if !hp! LEQ 0 (
        goto :lose
    ) 
    call :attack
    if !e_hp! LEQ 0 (
        goto :win
    ) 
)

pause
goto :battleLoop

:attack

rem get the attack's information
set /a _0 = !player_move!
call :getAttack

rem calibrate the attack multiplier
set /a _atkPow= 2

rem lower it if it's quick
if !_1! == 0 (
    set /a _atkPow= 1
) else if !_1! == 2 (
    set /a _atkPow= 3
)

set /a _moveType = !_2!
set /a _effect = 2

echo power triangle TODO
rem calculate power triangle
if !_moveType! == 0 (
    if !e_type! == 1 (
        rem half effective against water
        set /a _effect = 1
    ) else if !e_type! == 2 (
        rem super effective against grass
        set /a _effect = 3
    )
) else if !_moveType! == 1 (
    if !e_type! == 2 (
        rem half effective against grass
        set /a _effect = 1
    ) else if !e_type! == 0 (
        rem super effective against fire
        set /a _effect = 3
    )
) else if !_moveType! == 2 (
    if !e_type! == 0 (
        rem half effective against fire
        set /a _effect = 1
    ) else if !e_type! == 1 (
        rem super effective against water
        set /a _effect = 3
    )
)

rem account for defenses
if !e_defenses! == !_moveType! (
    set /a _effect = !_effect! - 1
)

rem account for possibly lt 0
if !_effect! LSS 0 (
    set /a _effect = 0
)

rem apply the effect to the multiplier
set /a _atkPow= !_atkPow! * !_effect! - !e_protection!

echo calculating effects TODO
if !_3! == 0 (
    rem physical
    set /a _atkPow= !_atkPow! * !atk! / 2

    if !_4! == 1 (
        rem defensive
        echo Resisting that move type!
        set /a defenses = !_moveType!
    ) else (
        rem offensive just deal damage
        set /a _atkPow = !_atkPow! - !e_def! / 4

        rem attack the spikes first
        if e_spikes GTR 0 (
            set /a _tmp = !e_spikes!
            set /a e_spikes = !e_spikes! - !_atkPow!
            if !e_spikes! GTR 0 (
                echo The spikes held and dealt damage!
                set /a hp = !hp! - e_mat / 8
            ) else (
                echo The spikes broke!
                set /a _atkPow = !e_spikes! * -1
            )
        )
        
        rem attack the barrier 
        set /a e_barrier = !e_barrier! - !_atkPow!
        rem if the barrier is broken,  deal damage through
        if !e_barrier! LSS 0 (
            echo The barrier was broken!
            echo The attack dealt !e_barrier! damage!
            set /a e_hp = !e_hp! + !e_barrier!
            set /a e_barrier = 0
        ) else (
            echo The barrier holds!
            echo The attack dealt !_atkPow! to the barrier.
        )
    )
) else (
    rem magic
    set /a _atkPow= !_atkPow! * !mat! / 2

    if !_4! == 1 (
        rem defensive
        if !_moveType! == 0 (
            set /a spikes = !_atkPow! / 2
        ) else if !_moveType! == 1 (
            set /a protection = 1
        ) else if !_moveType! == 2 (
            set /a grassUses = !grassUses! + 1
            set /a _heal_amt = !_atkPow! - !grassUses! - !grassUses!
            set /a hp = !hp! + !_heal_amt!
            echo healed !_heal_amt!
            if !hp! GTR !mhp! (
                set /a hp = !mhp!
            )
        ) else if !_moveType! == 3 (
            set /a barrier = !_atkPow!
        )
    ) else (
        rem offensive just deal damage
        set /a _atkPow = !_atkPow! - !e_mdf! / 4

        rem attack the spikes first
        if e_spikes GTR 0 (
            set /a _tmp = !e_spikes!
            set /a e_spikes = !e_spikes! - !_atkPow!
            if !e_spikes! GTR 0 (
                echo The spikes held and dealt damage!
                set /a hp = !hp! - e_mat / 8
            ) else (
                echo The spikes broke!
                set /a _atkPow = !e_spikes! * -1
            )
        )

        rem attack the barrier 
        set /a e_barrier = !e_barrier! - !_atkPow!
        rem if the barrier is broken,  deal damage through
        if !e_barrier! LSS 0 (
            echo The barrier was broken!
            echo The attack dealt !e_barrier! damage!
            set /a e_hp = !e_hp! + !e_barrier!
            set /a e_barrier = 0
        ) else (
            echo The barrier holds!
            echo The attack dealt !_atkPow! to the barrier.
        )
    )
)
endlocal & goto :eof


:getAttacked
rem get the attack's information
set /a _0 = !enemyAtk!
call :getAttack

echo The enemy is about to use !_5!^^!

rem calibrate the attack multiplier
set /a _atkPow= 2

rem lower it if it's quick
if !_1! == 0 (
    set /a _atkPow= 1
) else if !_1! == 2 (
    set /a _atkPow= 3
)

set /a _moveType = !_2!
set /a _effect = 2

rem calculate power triangle

if !_moveType! == 0 (
    if !type! == 1 (
        rem half effective against water
        set /a _effect = 1
    ) else if !type! == 2 (
        rem super effective against grass
        set /a _effect = 3
    )
) else if !_moveType! == 1 (
    if !type! == 2 (
        rem half effective against grass
        set /a _effect = 1
    ) else if !type! == 0 (
        rem super effective against fire
        set /a _effect = 3
    )
) else if !_moveType! == 2 (
    if !type! == 0 (
        rem half effective against fire
        set /a _effect = 1
    ) else if !type! == 1 (
        rem super effective against water
        set /a _effect = 3
    )
)

rem account for defenses
if !defenses! == !_moveType! (
    set /a _effect = !_effect! - 1
)

rem account for possibly lt 0
if !_effect! LSS 0 (
    set /a _effect = 0
)

rem apply the effect to the multiplier
set /a _atkPow= !_atkPow! * !_effect! - !protection!

echo Enemy attack calculations TODO
if !_3! == 0 (
    rem physical
    set /a _atkPow= !_atkPow! * !e_atk! / 2

    if !_4! == 1 (
        rem defensive
        echo Resisting that move type!
        set /a e_defenses = !_moveType!
    ) else (
        rem offensive just deal damage
        set /a _atkPow = !_atkPow! - !def! / 4

        rem attack the spikes first
        if spikes GTR 0 (
            set /a _tmp = !spikes!
            set /a spikes = !spikes! - !_atkPow!
            if !spikes! GTR 0 (
                echo The spikes held and dealt damage!
                set /a hp = !hp! - mat / 8
            ) else (
                echo The spikes broke!
                set /a _atkPow = !spikes! * -1
            )
        )
        
        rem attack the barrier 
        set /a barrier = !barrier! - !_atkPow!
        rem if the barrier is broken,  deal damage through
        if !barrier! LSS 0 (
            echo The barrier was broken!
            echo The attack dealt !barrier! damage!
            set /a hp = !hp! + !barrier!
            set /a barrier = 0
        ) else (
            echo The barrier holds!
            echo The attack dealt !_atkPow! to the barrier.
        )
    )
) else (
    rem magic
    set /a _atkPow= !_atkPow! * !e_mat! / 2

    if !_4! == 1 (
        rem defensive
        if !_moveType! == 0 (
            set /a e_spikes = !_atkPow! / 2
        ) else if !_moveType! == 1 (
            set /a e_protection = 1
        ) else if !_moveType! == 2 (
            set /a e_grassUses = !e_grassUses! + 1
            set /a _heal_amt = !_atkPow! - !e_grassUses! - !e_grassUses!
            set /a e_hp = !e_hp! + !_heal_amt!
            echo healed !_heal_amt!
            if !e_hp! GTR !e_mhp! (
                set /a e_hp = !e_mhp!
            )
        ) else if !_moveType! == 3 (
            set /a e_barrier = !_atkPow!
        )
    ) else (
        rem offensive just deal damage
        set /a _atkPow = !_atkPow! - !e_mdf! / 4

        rem attack the spikes first
        if spikes GTR 0 (
            set /a _tmp = !spikes!
            set /a spikes = !spikes! - !_atkPow!
            if !spikes! GTR 0 (
                echo The spikes held and dealt damage!
                set /a e_hp = !e_hp! - mat / 8
            ) else (
                echo The spikes broke!
                set /a _atkPow = !spikes! * -1
            )
        )

        rem attack the barrier 
        set /a barrier = !barrier! - !_atkPow!
        rem if the barrier is broken,  deal damage through
        if !barrier! LSS 0 (
            echo The barrier was broken!
            echo The attack dealt !barrier! damage!
            set /a hp = !hp! + !barrier!
            set /a barrier = 0
        ) else (
            echo The barrier holds!
            echo The attack dealt !_atkPow! to the barrier.
        )
    )
)
endlocal & goto :eof

:win
echo you win^^!
goto :eof

:lose
echo you lost...
goto :eof

:selectAttack
set /P usrIn=

set /A _selected = !usrIn!

set /A selected = !_selected! - 1

if !selected! LEQ 3 (
    if !selected! GEQ 0 (
        goto :turnExecute
    )
)

echo That is not a valid attack
goto :selectAttack


:getAttack
rem priority
set /a _1 = !_0! / 16

rem type
set /a _2 = !_0! %% 4

rem physicality
set /a _3 = !_0! %% 2

rem ofenssiveness
set /a _4 = !_0! / 2 %% 2

set _moveName=

if !_1! == 0 (
    set _moveName=Quick
) else if !_1! == 2 (
    set _moveName=Strong
)

if !_3! == 1 (
    set _moveName=%_moveName% Magical
)

if !_2! == 0 (
    set _moveName=%_moveName% Flame
) else if !_2! == 1 (
    set _moveName=%_moveName% Spout
) else if !_2! == 2 (
    set _moveName=%_moveName% Leaf
) else if !_2! == 3 (
    set _moveName=%_moveName% Beam
)

if !_4! == 1 (
    set _moveName=%_moveName% of Protection
)

endlocal & set _5=!_moveName! & goto :eof

:showAttacks
echo Your monster's attacks are

set /a _0=%move_1%
call :getAttack
echo 1. !_moveName!

set /a _0=%move_2%
call :getAttack
echo 2. !_moveName!

set /a _0=%move_3%
call :getAttack
echo 3. !_moveName!

set /a _0=%move_4%
call :getAttack
echo 4. !_moveName!

:generateRandomNumber
rem slow as hecc but works
FOR /F %%n IN ('powershell -NoLogo -NoProfile -Command Get-Random') DO (
    SET "RNUM=%%~n"
)
set /A randnum=%RNUM%
endlocal & set random=!randnum! & goto :eof
