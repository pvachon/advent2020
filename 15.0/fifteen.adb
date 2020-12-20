with Ada.Text_IO;

procedure Fifteen is
    package Text_IO renames Ada.Text_IO;

    Max_Turns : constant Natural := 2020;
    Initializer_Length : constant Natural := 6;
  --  Initializer_Length : constant Natural := 3;

    type Game_State is array(Natural range <>) of Integer;
    subtype Current_Game is Game_State(1..Max_Turns);

    game : Current_Game := (1 => 10,
                            2 => 16,
                            3 => 6,
                            4 => 0,
                            5 => 1,
                            6 => 17,
                            others => 0);

    --game : Current_Game := (1 => 10, 2 => 16, 3 => 6, others => 0);

    function Game_Round(previous : Game_State;
                        turn_number : Natural) return Integer
    is
        prior : Integer := previous(previous'Last);
        turn_count : Natural := 0;
        found : Boolean := false;
    begin

        -- Walk backwards, trying to find the prior instance of this
        for I in reverse previous'First..previous'Last - 1 loop
            turn_count := turn_count + 1;
            if previous(I) = prior then
                -- Found the prior instance of this number, so return
                found := true;
                exit;
            end if;
        end loop;

        if not found then
            return 0;
        end if;

        return turn_count;

    end Game_Round;

begin

    Text_IO.Put_Line("Advent of Code 15.0");

    Text_IO.Put(Integer'Image(game(game'First)));

    for J in game'First + 1..game'First + Initializer_Length - 1 loop
        Text_IO.Put(", " & Integer'Image(game(J)));
    end loop;

    for J in game'First + Initializer_Length.. game'Last loop

        game(J) := Game_Round(game(game'First..J-1), J);
        Text_IO.Put(", " & Integer'Image(game(J)));

    end loop;

end Fifteen;

