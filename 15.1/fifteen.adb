with Ada.Text_IO,
     Ada.Containers.Ordered_Maps;

procedure Fifteen is
    package Text_IO renames Ada.Text_IO;

    Max_Turns : constant Natural := 30000000;
    --Max_Turns : constant Natural := 2020;
    Initializer_Length : constant Natural := 6;

    package Memoizer is new Ada.Containers.Ordered_Maps(
        Key_Type => Integer,
        Element_Type => Natural);

    memoize : Memoizer.Map;

    function Game_Round(prev_turn : Integer;
                        turn_number : Natural) return Integer
    is
        use Memoizer;
        turn_count : Natural := 0;
        curs : Memoizer.Cursor := Memoizer.No_Element;
        new_elem : Integer := 0;
    begin
        -- Search memoized results
        curs := memoize.Find(prev_turn);
        if Memoizer.No_Element /= curs then
            -- Seen this number before
            new_elem := turn_number - Element(curs) - 1;
        else
            new_elem := 0;
        end if;

        memoize.Include(prev_turn, turn_number - 1);

        return new_elem;
    end Game_Round;

    prev_turn : Integer;
begin

    Text_IO.Put_Line("Advent of Code 15.1");

    memoize.Insert(10, 1);
    memoize.Insert(16, 2);
    memoize.Insert(6, 3);
    memoize.Insert(0, 4);
    memoize.Insert(1, 5);
    memoize.Insert(17, 6);

    prev_turn := 17;

    for J in Initializer_Length + 1.. Max_Turns loop
        prev_turn := Game_Round(prev_turn, J);
        if J mod 100000 = 0 then
            Text_IO.Put_Line("[" & Natural'Image(J) & "] = " & Integer'Image(prev_turn));
        end if;
        --Text_IO.Put(", " & Integer'Image(prev_turn));
    end loop;

    Text_IO.Put_Line("Item " & Natural'Image(Max_Turns) & " = " & Integer'Image(prev_turn));

end Fifteen;

