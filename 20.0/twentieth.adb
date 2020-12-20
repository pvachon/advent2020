with Ada.Text_IO,
     Ada.Command_Line,
     Ada.Containers.Ordered_Maps;

procedure Twentieth is
    package Text_IO renames Ada.Text_IO;
    package Command_Line renames Ada.Command_Line;

    file : Text_IO.File_Type;

    type Parse_State is (Header, Scanlines, Done);
    type Tile_ID is new Integer range 1..9999;

    subtype Scanline is String(1..10);
    type Tile_Raster is array(1..10) of Scanline;

    type Tile_Neighbours is array(1..4) of Tile_ID;

    scanline_id : Integer := 1;
    state : Parse_State := Header;
    ident : Tile_ID;
    raster : Tile_Raster;

    type Tile is
        record
            id : Tile_ID;
            raster : Tile_Raster;
            neighbours : Tile_Neighbours;
            neigh_hwm : Positive range 1..4;
            neigh_count : Natural;
        end record;

    package Tile_Map is new Ada.Containers.Ordered_Maps(
        Key_Type => Tile_ID,
        Element_Type => Tile);

    function Handle_Header(str : in String) return Tile_ID is
    begin
        if str(str'First..str'First + 4) /= "Tile " then
            Text_IO.Put_Line("Malformed tile header. Value: " & str);
            return 1;
        end if;

        return Tile_ID'Value(str(str'First + 5..str'First + 8));
    end Handle_Header;

    -- Extract a column as a scanline
    function Extract_Column(raster : in Tile_Raster;
                            col : in Natural) return Scanline
    is
        tmp : Scanline;
    begin
        for J in 1..10 loop
            tmp(J) := raster(J)(col);
        end loop;

        return tmp;
    end Extract_Column;

    function Reverse_Scanline(scl : in Scanline) return Scanline
    is
        tmp : Scanline;
    begin
        for I in scl'Range loop
            tmp(scl'Last - I + 1) := scl(I);
        end loop;
        return tmp;
    end Reverse_Scanline;

    function Scanline_Compare_Fwd_Rev(scl_src, scl_dst : in Scanline) return Boolean
    is
    begin
        return scl_src = scl_dst or Reverse_Scanline(scl_src) = scl_dst;
    end Scanline_Compare_Fwd_Rev;

    -- Check if the edges of the given tile match a given candidate
    function Check_Scanline_Column(scl : in Scanline;
                                   raster : in Tile_Raster) return Boolean
    is
    begin
        return Scanline_Compare_Fwd_Rev(scl, Extract_Column(raster, 1)) or
            Scanline_Compare_Fwd_Rev(scl, Extract_Column(raster, 10)) or
            Scanline_Compare_Fwd_Rev(scl, raster(1)) or
            Scanline_Compare_Fwd_Rev(scl, raster(10));
    end Check_Scanline_Column;

    procedure Update_Tile(tle : in out Tile;
                          match_id : in Tile_ID)
    is
    begin
        Text_IO.Put_Line("Updating Tile " & Tile_ID'Image(tle.id) & " with match " & Tile_ID'Image(match_id));
        tle.neigh_count := tle.neigh_count + 1;
        tle.neighbours(tle.neigh_hwm) := match_id;
        if tle.neigh_count /= 4 then
            tle.neigh_hwm := tle.neigh_hwm + 1;
        end if;
    end Update_Tile;

    -- Check if the given src tile can be matched to any edge of the
    -- destination tile. If so, mark it as a neighbour candidate
    function Check_Tile(tile_src : in out Tile;
                        tile_dst : in Tile) return boolean
    is
    begin
        if Check_Scanline_Column(Extract_Column(tile_src.raster, 1), tile_dst.raster) then
            Update_Tile(tile_src, tile_dst.id);
            return True;
        end if;

        if Check_Scanline_Column(Extract_Column(tile_src.raster, 10), tile_dst.raster) then
            Update_Tile(tile_src, tile_dst.id);
            return True;
        end if;

        if Check_Scanline_Column(tile_src.raster(1), tile_dst.raster) then
            Update_Tile(tile_src, tile_dst.id);
            return True;
        end if;

        if Check_Scanline_Column(tile_src.raster(10), tile_dst.raster) then
            Update_Tile(tile_src, tile_dst.id);
            return True;
        end if;

        return False;
    end Check_Tile;

    procedure Consume_Blank(str : in String) is
    begin
        return;
    end Consume_Blank;

    tile_counter : Integer := 0;

    all_tiles : Tile_Map.Map;
    cursor, inner : Tile_Map.Cursor;
    product : Long_Long_Integer := 1;
begin

    Text_IO.Put_Line("Advent of Code: 20.0");

    if Command_Line.Argument_Count /= 1 then
        Text_IO.Put_Line("Need to specify file of image tiles. Aborting.");
        return;
    end if;

	Text_IO.Put_Line("File name: " & Command_Line.Argument(1));

    Text_IO.Open(File => file,
                 Mode => Text_IO.In_File,
                 Name => Command_Line.Argument(1));

    while not Text_IO.End_Of_File(file) loop
        case state is
            when Header =>
                ident := Handle_Header(Text_IO.Get_Line(file));
                tile_counter := tile_counter + 1;
                Text_IO.Put_Line("Parsing tile " & Integer'Image(tile_counter) & " ID = " & Tile_ID'Image(ident));
                state := Scanlines;
                scanline_id := 1;
            when Scanlines =>
                raster(scanline_id) := Text_IO.Get_Line(file);
                scanline_id := scanline_id + 1;
                if scanline_id > 10 then
                    state := Done;
                end if;
            when Done =>
                all_tiles.Insert(ident, (id => ident, raster => raster, neighbours => (others => 1), neigh_hwm => 1,
                    neigh_count => 0));
                Consume_Blank(Text_IO.Get_Line(file));
                state := Header;
        end case;
    end loop;

    -- Iterate over tiles to try to match edges
    cursor := all_tiles.First;

    while Tile_Map.Has_Element(cursor) loop
        declare
            src : Tile := Tile_Map.Element(cursor);
        begin
            Text_IO.Put_Line("-->> Processing Tile <<--");
            inner := all_tiles.First;
            while Tile_Map.Has_Element(inner) loop
                if src.id /= Tile_Map.Key(inner) then
                    if Check_Tile(src, Tile_Map.Element(inner)) then
                        Text_IO.Put_Line("Found a match: an edge of " &
                            Tile_ID'Image(Tile_Map.Key(cursor)) & " to " &
                            Tile_ID'Image(Tile_Map.Key(inner)));
                    end if;
                end if;
                Tile_Map.Next(inner);
            end loop;
            Text_IO.Put_Line("Tile " & Tile_ID'Image(src.id) &
                " has " & Natural'Image(src.neigh_count) &
                " neighbours.");
            all_tiles.Replace_Element(cursor, src);
        end;
        Tile_Map.Next(cursor);
    end loop;

    -- Find tiles with exactly 2 candidate neighbours
    cursor := all_tiles.First;

    while Tile_Map.Has_Element(cursor) loop
        declare
            cand : Tile := Tile_Map.Element(cursor);
        begin
            if cand.neigh_count = 2 then
                Text_IO.Put_Line("Candidate Corner: " &
                    Tile_ID'Image(cand.id));
                product := product * Long_Long_Integer(cand.id);
            end if;
        end;
        Tile_Map.Next(cursor);
    end loop;

    Text_IO.Put_Line("Product: " & Long_Long_Integer'Image(product));

end Twentieth;

