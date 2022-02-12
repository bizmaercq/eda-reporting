DECLARE

CURSOR cur_cl_account IS SELECT ACCOUNT_NUMBER FROM CLTB_ACCOUNT_MASTER
				WHERE 
				ACCOUNT_NUMBER = '&ACCOUNT_NUMBER'
				;
l_pwhere	VARCHAR2(35);
l_directory VARCHAR2(35);
l_filename	VARCHAR2(35);
procedure dump_tbl(t varchar2,
                                     w varchar2 := null,
                                     d varchar2 := '/tmp/',
                                     n varchar2 := 'dump.lst',
                                     m varchar2 := 'a')
as

/*----------------------------------------------------------------------------------------
**
** File Name	: IFPRDTBL.PRC
**
** Module	: IF
**
** This source is part of the FLEXCUBE Corporate - Corporate Banking Software System
** and is copyrighted by i-flex solutions limited.
**
** All rights reserved.  No part of this work may be reproduced, stored in a
** retrieval system, adopted or transmitted in any form or by any means, electronic,
** mechanical, photographic, graphic, optic recording or otherwise, translated in
** any language or computer language, without the prior written permission of
** i-flex Solutions Limited.
**
** i-flex solutions limited.
** 10-11, SDF I, SEEPZ, Andheri (East),
** Mumbai - 400 096.
** India
**
** Copyright? 2003 by i-flex solutions limited
**
----------------------------------------------------------------------------------------*/

/**
CHANGE HISTORY

18-NOV-2003 FCC 4.4 DEC 2003 This procedure is released as a new unit in the site specific folder.

**/

	f utl_file.file_type := utl_file.fopen(d,n,m,32767);
	dt_fmt varchar2(64);
	outbuff VARCHAR2(32767) := NULL;
	sbuf_len integer := 0; -- Length of String Buffer = Length(outbuff)
	curr_line_length integer := 0; -- Split if current Line exceeds 1000 Chars
	c integer;
	-- type VC2_TAB is table of VARCHAR2(32767) index by binary_integer;
	V1 VARCHAR2(32767);
	V2 VARCHAR2(32767);
	V3 VARCHAR2(32767);
	V4 VARCHAR2(32767);
	V5 VARCHAR2(32767);
	V6 VARCHAR2(32767);
	V7 VARCHAR2(32767);
	V8 VARCHAR2(32767);
	V9 VARCHAR2(32767);
	V10 VARCHAR2(32767);
	V11 VARCHAR2(32767);
	V12 VARCHAR2(32767);
	V13 VARCHAR2(32767);
	V14 VARCHAR2(32767);
	V15 VARCHAR2(32767);
	V16 VARCHAR2(32767);
	V17 VARCHAR2(32767);
	V18 VARCHAR2(32767);
	V19 VARCHAR2(32767);
	V20 VARCHAR2(32767);
	V21 VARCHAR2(32767);
	V22 VARCHAR2(32767);
	V23 VARCHAR2(32767);
	V24 VARCHAR2(32767);
	V25 VARCHAR2(32767);
	V26 VARCHAR2(32767);
	V27 VARCHAR2(32767);
	V28 VARCHAR2(32767);
	V29 VARCHAR2(32767);
	V30 VARCHAR2(32767);
	V31 VARCHAR2(32767);
	V32 VARCHAR2(32767);
	V33 VARCHAR2(32767);
	V34 VARCHAR2(32767);
	V35 VARCHAR2(32767);
	V36 VARCHAR2(32767);
	V37 VARCHAR2(32767);
	V38 VARCHAR2(32767);
	V39 VARCHAR2(32767);
	V40 VARCHAR2(32767);
	V41 VARCHAR2(32767);
	V42 VARCHAR2(32767);
	V43 VARCHAR2(32767);
	V44 VARCHAR2(32767);
	V45 VARCHAR2(32767);
	V46 VARCHAR2(32767);
	V47 VARCHAR2(32767);
	V48 VARCHAR2(32767);
	V49 VARCHAR2(32767);
	V50 VARCHAR2(32767);
	V51 VARCHAR2(32767);
	V52 VARCHAR2(32767);
	V53 VARCHAR2(32767);
	V54 VARCHAR2(32767);
	V55 VARCHAR2(32767);
	V56 VARCHAR2(32767);
	V57 VARCHAR2(32767);
	V58 VARCHAR2(32767);
	V59 VARCHAR2(32767);
	V60 VARCHAR2(32767);
	V61 VARCHAR2(32767);
	V62 VARCHAR2(32767);
	V63 VARCHAR2(32767);
	V64 VARCHAR2(32767);
	V65 VARCHAR2(32767);
	V66 VARCHAR2(32767);
	V67 VARCHAR2(32767);
	V68 VARCHAR2(32767);
	V69 VARCHAR2(32767);
	V70 VARCHAR2(32767);
	V71 VARCHAR2(32767);
	V72 VARCHAR2(32767);
	V73 VARCHAR2(32767);
	V74 VARCHAR2(32767);
	V75 VARCHAR2(32767);
	V76 VARCHAR2(32767);
	V77 VARCHAR2(32767);
	V78 VARCHAR2(32767);
	V79 VARCHAR2(32767);
	V80 VARCHAR2(32767);
	V81 VARCHAR2(32767);
	V82 VARCHAR2(32767);
	V83 VARCHAR2(32767);
	V84 VARCHAR2(32767);
	V85 VARCHAR2(32767);
	V86 VARCHAR2(32767);
	V87 VARCHAR2(32767);
	V88 VARCHAR2(32767);
	V89 VARCHAR2(32767);
	V90 VARCHAR2(32767);
	V91 VARCHAR2(32767);
	V92 VARCHAR2(32767);
	V93 VARCHAR2(32767);
	V94 VARCHAR2(32767);
	V95 VARCHAR2(32767);
	V96 VARCHAR2(32767);
	V97 VARCHAR2(32767);
	V98 VARCHAR2(32767);
	V99 VARCHAR2(32767);
	V100 VARCHAR2(32767);
	V101 VARCHAR2(32767);
	V102 VARCHAR2(32767);
	V103 VARCHAR2(32767);
	V104 VARCHAR2(32767);
	V105 VARCHAR2(32767);
	V106 VARCHAR2(32767);
	V107 VARCHAR2(32767);
	V108 VARCHAR2(32767);
	V109 VARCHAR2(32767);
	V110 VARCHAR2(32767);
	V111 VARCHAR2(32767);
	V112 VARCHAR2(32767);
	V113 VARCHAR2(32767);
	V114 VARCHAR2(32767);
	V115 VARCHAR2(32767);
	V116 VARCHAR2(32767);
	V117 VARCHAR2(32767);
	V118 VARCHAR2(32767);
	V119 VARCHAR2(32767);
	V120 VARCHAR2(32767);
	V121 VARCHAR2(32767);
	V122 VARCHAR2(32767);
	V123 VARCHAR2(32767);
	V124 VARCHAR2(32767);
	V125 VARCHAR2(32767);
	V126 VARCHAR2(32767);
	V127 VARCHAR2(32767);
	V128 VARCHAR2(32767);
	V129 VARCHAR2(32767);
	V130 VARCHAR2(32767);
	V131 VARCHAR2(32767);
	V132 VARCHAR2(32767);
	V133 VARCHAR2(32767);
	V134 VARCHAR2(32767);
	V135 VARCHAR2(32767);
	V136 VARCHAR2(32767);
	V137 VARCHAR2(32767);
	V138 VARCHAR2(32767);
	V139 VARCHAR2(32767);
	V140 VARCHAR2(32767);
	V141 VARCHAR2(32767);
	V142 VARCHAR2(32767);
	V143 VARCHAR2(32767);
	V144 VARCHAR2(32767);
	V145 VARCHAR2(32767);
	V146 VARCHAR2(32767);
	V147 VARCHAR2(32767);
	V148 VARCHAR2(32767);
	V149 VARCHAR2(32767);
	V150 VARCHAR2(32767);
	V151 VARCHAR2(32767);
	V152 VARCHAR2(32767);
	V153 VARCHAR2(32767);
	V154 VARCHAR2(32767);
	V155 VARCHAR2(32767);
	V156 VARCHAR2(32767);
	V157 VARCHAR2(32767);
	V158 VARCHAR2(32767);
	V159 VARCHAR2(32767);
	V160 VARCHAR2(32767);
	V161 VARCHAR2(32767);
	V162 VARCHAR2(32767);
	V163 VARCHAR2(32767);
	V164 VARCHAR2(32767);
	V165 VARCHAR2(32767);
	V166 VARCHAR2(32767);
	V167 VARCHAR2(32767);
	V168 VARCHAR2(32767);
	V169 VARCHAR2(32767);
	V170 VARCHAR2(32767);
	V171 VARCHAR2(32767);
	V172 VARCHAR2(32767);
	V173 VARCHAR2(32767);
	V174 VARCHAR2(32767);
	V175 VARCHAR2(32767);
	V176 VARCHAR2(32767);
	V177 VARCHAR2(32767);
	V178 VARCHAR2(32767);
	V179 VARCHAR2(32767);
	V180 VARCHAR2(32767);
	V181 VARCHAR2(32767);
	V182 VARCHAR2(32767);
	V183 VARCHAR2(32767);
	V184 VARCHAR2(32767);
	V185 VARCHAR2(32767);
	V186 VARCHAR2(32767);
	V187 VARCHAR2(32767);
	V188 VARCHAR2(32767);
	V189 VARCHAR2(32767);
	V190 VARCHAR2(32767);
	V191 VARCHAR2(32767);
	V192 VARCHAR2(32767);
query_str VARCHAR2(32767);
insert_base VARCHAR2(32767);
ins_len integer;
cur_fld VARCHAR2(32767);
type ty_col_tab is table of cols%rowtype index by binary_integer;
col_tab ty_col_tab;
table_name tabs.table_name%type;
n_cols integer;
i integer :=0;
j integer :=0;
k integer :=0;
l integer :=0;
procedure frame_query(t varchar2,w varchar2)
is
	i integer := 0;
begin
	for x in (select * from cols where table_name = t order by column_id)
	loop
	    i := i+1;
		col_tab(i) := x;
		if i = 1 then
			insert_base := 'INSERT INTO ' || t || '(' || x.column_name;
		else
			insert_base := insert_base || chr(10) || ','||x.column_name;
		end if;
	end loop;
	if i > 0 then
		query_str := 'SELECT * FROM ' || t; -- query_str || ' FROM ' || t;
		if (w is not null) then
		   if upper(substr(w,1,5)) != 'WHERE' then
		   	  query_str := query_str || ' WHERE';
			end if;
			query_str := query_str || ' ' || w;
		end if;
		insert_base := insert_base || ') VALUES(';
		ins_len := length(insert_base);
	end if;
	n_cols := i;
	-- -- dbms_output.put_line('AFTER FRAME');
end frame_query;
procedure define_arrays(c integer,n_cols integer)
is
l_pos NUMBER := 0;
begin
if N_COLS >= 1 then
	dbms_sql.DEFINE_COLUMN(c,1,V1,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 2 then
	dbms_sql.DEFINE_COLUMN(c,2,V2,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 3 then
	dbms_sql.DEFINE_COLUMN(c,3,V3,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 4 then
	dbms_sql.DEFINE_COLUMN(c,4,V4,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 5 then
	dbms_sql.DEFINE_COLUMN(c,5,V5,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 6 then
	dbms_sql.DEFINE_COLUMN(c,6,V6,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 7 then
	dbms_sql.DEFINE_COLUMN(c,7,V7,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 8 then
	dbms_sql.DEFINE_COLUMN(c,8,V8,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 9 then
	dbms_sql.DEFINE_COLUMN(c,9,V9,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 10 then
	dbms_sql.DEFINE_COLUMN(c,10,V10,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 11 then
	dbms_sql.DEFINE_COLUMN(c,11,V11,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 12 then
	dbms_sql.DEFINE_COLUMN(c,12,V12,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 13 then
	dbms_sql.DEFINE_COLUMN(c,13,V13,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 14 then
	dbms_sql.DEFINE_COLUMN(c,14,V14,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 15 then
	dbms_sql.DEFINE_COLUMN(c,15,V15,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 16 then
	dbms_sql.DEFINE_COLUMN(c,16,V16,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 17 then
	dbms_sql.DEFINE_COLUMN(c,17,V17,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 18 then
	dbms_sql.DEFINE_COLUMN(c,18,V18,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 19 then
	dbms_sql.DEFINE_COLUMN(c,19,V19,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 20 then
	dbms_sql.DEFINE_COLUMN(c,20,V20,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 21 then
	dbms_sql.DEFINE_COLUMN(c,21,V21,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 22 then
	dbms_sql.DEFINE_COLUMN(c,22,V22,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 23 then
	dbms_sql.DEFINE_COLUMN(c,23,V23,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 24 then
	dbms_sql.DEFINE_COLUMN(c,24,V24,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 25 then
	dbms_sql.DEFINE_COLUMN(c,25,V25,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 26 then
	dbms_sql.DEFINE_COLUMN(c,26,V26,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 27 then
	dbms_sql.DEFINE_COLUMN(c,27,V27,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 28 then
	dbms_sql.DEFINE_COLUMN(c,28,V28,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 29 then
	dbms_sql.DEFINE_COLUMN(c,29,V29,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 30 then
	dbms_sql.DEFINE_COLUMN(c,30,V30,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 31 then
	dbms_sql.DEFINE_COLUMN(c,31,V31,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 32 then
	dbms_sql.DEFINE_COLUMN(c,32,V32,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 33 then
	dbms_sql.DEFINE_COLUMN(c,33,V33,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 34 then
	dbms_sql.DEFINE_COLUMN(c,34,V34,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 35 then
	dbms_sql.DEFINE_COLUMN(c,35,V35,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 36 then
	dbms_sql.DEFINE_COLUMN(c,36,V36,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 37 then
	dbms_sql.DEFINE_COLUMN(c,37,V37,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 38 then
	dbms_sql.DEFINE_COLUMN(c,38,V38,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 39 then
	dbms_sql.DEFINE_COLUMN(c,39,V39,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 40 then
	dbms_sql.DEFINE_COLUMN(c,40,V40,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 41 then
	dbms_sql.DEFINE_COLUMN(c,41,V41,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 42 then
	dbms_sql.DEFINE_COLUMN(c,42,V42,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 43 then
	dbms_sql.DEFINE_COLUMN(c,43,V43,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 44 then
	dbms_sql.DEFINE_COLUMN(c,44,V44,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 45 then
	dbms_sql.DEFINE_COLUMN(c,45,V45,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 46 then
	dbms_sql.DEFINE_COLUMN(c,46,V46,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 47 then
	dbms_sql.DEFINE_COLUMN(c,47,V47,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 48 then
	dbms_sql.DEFINE_COLUMN(c,48,V48,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 49 then
	dbms_sql.DEFINE_COLUMN(c,49,V49,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 50 then
	dbms_sql.DEFINE_COLUMN(c,50,V50,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 51 then
	dbms_sql.DEFINE_COLUMN(c,51,V51,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 52 then
	dbms_sql.DEFINE_COLUMN(c,52,V52,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 53 then
	dbms_sql.DEFINE_COLUMN(c,53,V53,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 54 then
	dbms_sql.DEFINE_COLUMN(c,54,V54,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 55 then
	dbms_sql.DEFINE_COLUMN(c,55,V55,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 56 then
	dbms_sql.DEFINE_COLUMN(c,56,V56,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 57 then
	dbms_sql.DEFINE_COLUMN(c,57,V57,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 58 then
	dbms_sql.DEFINE_COLUMN(c,58,V58,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 59 then
	dbms_sql.DEFINE_COLUMN(c,59,V59,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 60 then
	dbms_sql.DEFINE_COLUMN(c,60,V60,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 61 then
	dbms_sql.DEFINE_COLUMN(c,61,V61,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 62 then
	dbms_sql.DEFINE_COLUMN(c,62,V62,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 63 then
	dbms_sql.DEFINE_COLUMN(c,63,V63,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 64 then
	dbms_sql.DEFINE_COLUMN(c,64,V64,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 65 then
	dbms_sql.DEFINE_COLUMN(c,65,V65,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 66 then
	dbms_sql.DEFINE_COLUMN(c,66,V66,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 67 then
	dbms_sql.DEFINE_COLUMN(c,67,V67,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 68 then
	dbms_sql.DEFINE_COLUMN(c,68,V68,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 69 then
	dbms_sql.DEFINE_COLUMN(c,69,V69,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 70 then
	dbms_sql.DEFINE_COLUMN(c,70,V70,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 71 then
	dbms_sql.DEFINE_COLUMN(c,71,V71,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 72 then
	dbms_sql.DEFINE_COLUMN(c,72,V72,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 73 then
	dbms_sql.DEFINE_COLUMN(c,73,V73,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 74 then
	dbms_sql.DEFINE_COLUMN(c,74,V74,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 75 then
	dbms_sql.DEFINE_COLUMN(c,75,V75,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 76 then
	dbms_sql.DEFINE_COLUMN(c,76,V76,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 77 then
	dbms_sql.DEFINE_COLUMN(c,77,V77,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 78 then
	dbms_sql.DEFINE_COLUMN(c,78,V78,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 79 then
	dbms_sql.DEFINE_COLUMN(c,79,V79,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 80 then
	dbms_sql.DEFINE_COLUMN(c,80,V80,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 81 then
	dbms_sql.DEFINE_COLUMN(c,81,V81,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 82 then
	dbms_sql.DEFINE_COLUMN(c,82,V82,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 83 then
	dbms_sql.DEFINE_COLUMN(c,83,V83,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 84 then
	dbms_sql.DEFINE_COLUMN(c,84,V84,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 85 then
	dbms_sql.DEFINE_COLUMN(c,85,V85,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 86 then
	dbms_sql.DEFINE_COLUMN(c,86,V86,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 87 then
	dbms_sql.DEFINE_COLUMN(c,87,V87,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 88 then
	dbms_sql.DEFINE_COLUMN(c,88,V88,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 89 then
	dbms_sql.DEFINE_COLUMN(c,89,V89,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 90 then
	dbms_sql.DEFINE_COLUMN(c,90,V90,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 91 then
	dbms_sql.DEFINE_COLUMN(c,91,V91,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 92 then
	dbms_sql.DEFINE_COLUMN(c,92,V92,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 93 then
	dbms_sql.DEFINE_COLUMN(c,93,V93,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 94 then
	dbms_sql.DEFINE_COLUMN(c,94,V94,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 95 then
	dbms_sql.DEFINE_COLUMN(c,95,V95,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 96 then
	dbms_sql.DEFINE_COLUMN(c,96,V96,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 97 then
	dbms_sql.DEFINE_COLUMN(c,97,V97,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 98 then
	dbms_sql.DEFINE_COLUMN(c,98,V98,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 99 then
	dbms_sql.DEFINE_COLUMN(c,99,V99,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 100 then
	dbms_sql.DEFINE_COLUMN(c,100,V100,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 101 then
	dbms_sql.DEFINE_COLUMN(c,101,V101,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 102 then
	dbms_sql.DEFINE_COLUMN(c,102,V102,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 103 then
	dbms_sql.DEFINE_COLUMN(c,103,V103,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 104 then
	dbms_sql.DEFINE_COLUMN(c,104,V104,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 105 then
	dbms_sql.DEFINE_COLUMN(c,105,V105,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 106 then
	dbms_sql.DEFINE_COLUMN(c,106,V106,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 107 then
	dbms_sql.DEFINE_COLUMN(c,107,V107,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 108 then
	dbms_sql.DEFINE_COLUMN(c,108,V108,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 109 then
	dbms_sql.DEFINE_COLUMN(c,109,V109,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 110 then
	dbms_sql.DEFINE_COLUMN(c,110,V110,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if n_cols >= 111 then
	dbms_sql.DEFINE_COLUMN(c,111,V111,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 112 then
	dbms_sql.DEFINE_COLUMN(c,112,V112,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 113 then
	dbms_sql.DEFINE_COLUMN(c,113,V113,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 114 then
	dbms_sql.DEFINE_COLUMN(c,114,V114,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 115 then
	dbms_sql.DEFINE_COLUMN(c,115,V115,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 116 then
	dbms_sql.DEFINE_COLUMN(c,116,V116,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 117 then
	dbms_sql.DEFINE_COLUMN(c,117,V117,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 118 then
	dbms_sql.DEFINE_COLUMN(c,118,V118,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 119 then
	dbms_sql.DEFINE_COLUMN(c,119,V119,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 120 then
	dbms_sql.DEFINE_COLUMN(c,120,V120,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 121 then
	dbms_sql.DEFINE_COLUMN(c,121,V121,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 122 then
	dbms_sql.DEFINE_COLUMN(c,122,V122,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 123 then
	dbms_sql.DEFINE_COLUMN(c,123,V123,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 124 then
	dbms_sql.DEFINE_COLUMN(c,124,V124,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 125 then
	dbms_sql.DEFINE_COLUMN(c,125,V125,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 126 then
	dbms_sql.DEFINE_COLUMN(c,126,V126,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 127 then
	dbms_sql.DEFINE_COLUMN(c,127,V127,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 128 then
	dbms_sql.DEFINE_COLUMN(c,128,V128,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 129 then
	dbms_sql.DEFINE_COLUMN(c,129,V129,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 130 then
	dbms_sql.DEFINE_COLUMN(c,130,V130,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 131 then
	dbms_sql.DEFINE_COLUMN(c,131,V131,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 132 then
	dbms_sql.DEFINE_COLUMN(c,132,V132,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 133 then
	dbms_sql.DEFINE_COLUMN(c,133,V133,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 134 then
	dbms_sql.DEFINE_COLUMN(c,134,V134,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 135 then
	dbms_sql.DEFINE_COLUMN(c,135,V135,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 136 then
	dbms_sql.DEFINE_COLUMN(c,136,V136,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 137 then
	dbms_sql.DEFINE_COLUMN(c,137,V137,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 138 then
	dbms_sql.DEFINE_COLUMN(c,138,V138,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 139 then
	dbms_sql.DEFINE_COLUMN(c,139,V139,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 140 then
	dbms_sql.DEFINE_COLUMN(c,140,V140,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 141 then
	dbms_sql.DEFINE_COLUMN(c,141,V141,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 142 then
	dbms_sql.DEFINE_COLUMN(c,142,V142,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 143 then
	dbms_sql.DEFINE_COLUMN(c,143,V143,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 144 then
	dbms_sql.DEFINE_COLUMN(c,144,V144,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 145 then
	dbms_sql.DEFINE_COLUMN(c,145,V145,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 146 then
	dbms_sql.DEFINE_COLUMN(c,146,V146,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 147 then
	dbms_sql.DEFINE_COLUMN(c,147,V147,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 148 then
	dbms_sql.DEFINE_COLUMN(c,148,V148,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 149 then
	dbms_sql.DEFINE_COLUMN(c,149,V149,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 150 then
	dbms_sql.DEFINE_COLUMN(c,150,V150,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 151 then
	dbms_sql.DEFINE_COLUMN(c,151,V151,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 152 then
	dbms_sql.DEFINE_COLUMN(c,152,V152,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 153 then
	dbms_sql.DEFINE_COLUMN(c,153,V153,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 154 then
	dbms_sql.DEFINE_COLUMN(c,154,V154,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 155 then
	dbms_sql.DEFINE_COLUMN(c,155,V155,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 156 then
	dbms_sql.DEFINE_COLUMN(c,156,V156,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 157 then
	dbms_sql.DEFINE_COLUMN(c,157,V157,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 158 then
	dbms_sql.DEFINE_COLUMN(c,158,V158,32767);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Defined ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 159 then
	dbms_sql.DEFINE_COLUMN(c,159,V159,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 160 then
	dbms_sql.DEFINE_COLUMN(c,160,V160,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 161 then
	dbms_sql.DEFINE_COLUMN(c,161,V161,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 162 then
	dbms_sql.DEFINE_COLUMN(c,162,V162,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 163 then
	dbms_sql.DEFINE_COLUMN(c,163,V163,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 164 then
	dbms_sql.DEFINE_COLUMN(c,164,V164,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 165 then
	dbms_sql.DEFINE_COLUMN(c,165,V165,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 166 then
	dbms_sql.DEFINE_COLUMN(c,166,V166,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 167 then
	dbms_sql.DEFINE_COLUMN(c,167,V167,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 168 then
	dbms_sql.DEFINE_COLUMN(c,168,V168,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 169 then
	dbms_sql.DEFINE_COLUMN(c,169,V169,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 170 then
	dbms_sql.DEFINE_COLUMN(c,170,V170,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 171 then
	dbms_sql.DEFINE_COLUMN(c,171,V171,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 172 then
	dbms_sql.DEFINE_COLUMN(c,172,V172,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 173 then
	dbms_sql.DEFINE_COLUMN(c,173,V173,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 174 then
	dbms_sql.DEFINE_COLUMN(c,174,V174,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 175 then
	dbms_sql.DEFINE_COLUMN(c,175,V175,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 176 then
	dbms_sql.DEFINE_COLUMN(c,176,V176,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 177 then
	dbms_sql.DEFINE_COLUMN(c,177,V177,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 178 then
	dbms_sql.DEFINE_COLUMN(c,178,V178,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 179 then
	dbms_sql.DEFINE_COLUMN(c,179,V179,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 180 then
	dbms_sql.DEFINE_COLUMN(c,180,V180,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 181 then
	dbms_sql.DEFINE_COLUMN(c,181,V181,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 182 then
	dbms_sql.DEFINE_COLUMN(c,182,V182,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 183 then
	dbms_sql.DEFINE_COLUMN(c,183,V183,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 184 then
	dbms_sql.DEFINE_COLUMN(c,184,V184,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 185 then
	dbms_sql.DEFINE_COLUMN(c,185,V185,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 186 then
	dbms_sql.DEFINE_COLUMN(c,186,V186,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 187 then
	dbms_sql.DEFINE_COLUMN(c,187,V187,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 188 then
	dbms_sql.DEFINE_COLUMN(c,188,V188,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 189 then
	dbms_sql.DEFINE_COLUMN(c,189,V189,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 190 then
	dbms_sql.DEFINE_COLUMN(c,190,V190,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 191 then
	dbms_sql.DEFINE_COLUMN(c,191,V191,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 192 then
	dbms_sql.DEFINE_COLUMN(c,192,V192,32767);
ELSE
	RETURN;
end if;
/*
if N_COLS >= 193 then
	dbms_sql.DEFINE_COLUMN(c,193,V193,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 194 then
	dbms_sql.DEFINE_COLUMN(c,194,V194,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 195 then
	dbms_sql.DEFINE_COLUMN(c,195,V195,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 196 then
	dbms_sql.DEFINE_COLUMN(c,196,V196,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 197 then
	dbms_sql.DEFINE_COLUMN(c,197,V197,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 198 then
	dbms_sql.DEFINE_COLUMN(c,198,V198,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 199 then
	dbms_sql.DEFINE_COLUMN(c,199,V199,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 200 then
	dbms_sql.DEFINE_COLUMN(c,200,V200,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 201 then
	dbms_sql.DEFINE_COLUMN(c,201,V201,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 202 then
	dbms_sql.DEFINE_COLUMN(c,202,V202,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 203 then
	dbms_sql.DEFINE_COLUMN(c,203,V203,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 204 then
	dbms_sql.DEFINE_COLUMN(c,204,V204,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 205 then
	dbms_sql.DEFINE_COLUMN(c,205,V205,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 206 then
	dbms_sql.DEFINE_COLUMN(c,206,V206,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 207 then
	dbms_sql.DEFINE_COLUMN(c,207,V207,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 208 then
	dbms_sql.DEFINE_COLUMN(c,208,V208,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 209 then
	dbms_sql.DEFINE_COLUMN(c,209,V209,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 210 then
	dbms_sql.DEFINE_COLUMN(c,210,V210,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 211 then
	dbms_sql.DEFINE_COLUMN(c,211,V211,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 212 then
	dbms_sql.DEFINE_COLUMN(c,212,V212,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 213 then
	dbms_sql.DEFINE_COLUMN(c,213,V213,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 214 then
	dbms_sql.DEFINE_COLUMN(c,214,V214,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 215 then
	dbms_sql.DEFINE_COLUMN(c,215,V215,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 216 then
	dbms_sql.DEFINE_COLUMN(c,216,V216,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 217 then
	dbms_sql.DEFINE_COLUMN(c,217,V217,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 218 then
	dbms_sql.DEFINE_COLUMN(c,218,V218,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 219 then
	dbms_sql.DEFINE_COLUMN(c,219,V219,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 220 then
	dbms_sql.DEFINE_COLUMN(c,220,V220,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 221 then
	dbms_sql.DEFINE_COLUMN(c,221,V221,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 222 then
	dbms_sql.DEFINE_COLUMN(c,222,V222,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 223 then
	dbms_sql.DEFINE_COLUMN(c,223,V223,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 224 then
	dbms_sql.DEFINE_COLUMN(c,224,V224,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 225 then
	dbms_sql.DEFINE_COLUMN(c,225,V225,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 226 then
	dbms_sql.DEFINE_COLUMN(c,226,V226,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 227 then
	dbms_sql.DEFINE_COLUMN(c,227,V227,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 228 then
	dbms_sql.DEFINE_COLUMN(c,228,V228,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 229 then
	dbms_sql.DEFINE_COLUMN(c,229,V229,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 230 then
	dbms_sql.DEFINE_COLUMN(c,230,V230,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 231 then
	dbms_sql.DEFINE_COLUMN(c,231,V231,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 232 then
	dbms_sql.DEFINE_COLUMN(c,232,V232,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 233 then
	dbms_sql.DEFINE_COLUMN(c,233,V233,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 234 then
	dbms_sql.DEFINE_COLUMN(c,234,V234,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 235 then
	dbms_sql.DEFINE_COLUMN(c,235,V235,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 236 then
	dbms_sql.DEFINE_COLUMN(c,236,V236,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 237 then
	dbms_sql.DEFINE_COLUMN(c,237,V237,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 238 then
	dbms_sql.DEFINE_COLUMN(c,238,V238,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 239 then
	dbms_sql.DEFINE_COLUMN(c,239,V239,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 240 then
	dbms_sql.DEFINE_COLUMN(c,240,V240,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 241 then
	dbms_sql.DEFINE_COLUMN(c,241,V241,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 242 then
	dbms_sql.DEFINE_COLUMN(c,242,V242,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 243 then
	dbms_sql.DEFINE_COLUMN(c,243,V243,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 244 then
	dbms_sql.DEFINE_COLUMN(c,244,V244,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 245 then
	dbms_sql.DEFINE_COLUMN(c,245,V245,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 246 then
	dbms_sql.DEFINE_COLUMN(c,246,V246,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 247 then
	dbms_sql.DEFINE_COLUMN(c,247,V247,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 248 then
	dbms_sql.DEFINE_COLUMN(c,248,V248,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 249 then
	dbms_sql.DEFINE_COLUMN(c,249,V249,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 250 then
	dbms_sql.DEFINE_COLUMN(c,250,V250,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 251 then
	dbms_sql.DEFINE_COLUMN(c,251,V251,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 252 then
	dbms_sql.DEFINE_COLUMN(c,252,V252,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 253 then
	dbms_sql.DEFINE_COLUMN(c,253,V253,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 254 then
	dbms_sql.DEFINE_COLUMN(c,254,V254,32767);
ELSE
	RETURN;
end if;
if N_COLS >= 255 then
	dbms_sql.DEFINE_COLUMN(c,255,V255,32767);
ELSE
	RETURN;
end if;
*/
exception
	when others then
		-- utl_file.put_line(f,'DEFINE_ARRAY');
		-- utl_file.put_line(f,sqlerrm);
		raise;
end define_arrays;
procedure column_values(c integer,n_cols integer)
is
l_pos NUMBER := 0;
begin
-- dbms_output.put_line ('Getting value for column number ' || n_cols);
if N_COLS >= 1 then
	dbms_sql.COLUMN_VALUE(c,1,V1);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 2 then
	dbms_sql.COLUMN_VALUE(c,2,V2);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 3 then
	dbms_sql.COLUMN_VALUE(c,3,V3);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 4 then
	dbms_sql.COLUMN_VALUE(c,4,V4);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 5 then
	dbms_sql.COLUMN_VALUE(c,5,V5);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 6 then
	dbms_sql.COLUMN_VALUE(c,6,V6);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 7 then
	dbms_sql.COLUMN_VALUE(c,7,V7);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 8 then
	dbms_sql.COLUMN_VALUE(c,8,V8);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 9 then
	dbms_sql.COLUMN_VALUE(c,9,V9);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 10 then
	dbms_sql.COLUMN_VALUE(c,10,V10);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 11 then
	dbms_sql.COLUMN_VALUE(c,11,V11);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 12 then
	dbms_sql.COLUMN_VALUE(c,12,V12);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 13 then
	dbms_sql.COLUMN_VALUE(c,13,V13);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 14 then
	dbms_sql.COLUMN_VALUE(c,14,V14);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 15 then
	dbms_sql.COLUMN_VALUE(c,15,V15);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 16 then
	dbms_sql.COLUMN_VALUE(c,16,V16);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 17 then
	dbms_sql.COLUMN_VALUE(c,17,V17);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 18 then
	dbms_sql.COLUMN_VALUE(c,18,V18);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 19 then
	dbms_sql.COLUMN_VALUE(c,19,V19);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 20 then
	dbms_sql.COLUMN_VALUE(c,20,V20);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 21 then
	dbms_sql.COLUMN_VALUE(c,21,V21);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 22 then
	dbms_sql.COLUMN_VALUE(c,22,V22);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 23 then
	dbms_sql.COLUMN_VALUE(c,23,V23);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 24 then
	dbms_sql.COLUMN_VALUE(c,24,V24);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 25 then
	dbms_sql.COLUMN_VALUE(c,25,V25);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 26 then
	dbms_sql.COLUMN_VALUE(c,26,V26);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 27 then
	dbms_sql.COLUMN_VALUE(c,27,V27);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 28 then
	dbms_sql.COLUMN_VALUE(c,28,V28);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 29 then
	dbms_sql.COLUMN_VALUE(c,29,V29);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 30 then
	dbms_sql.COLUMN_VALUE(c,30,V30);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 31 then
	dbms_sql.COLUMN_VALUE(c,31,V31);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 32 then
	dbms_sql.COLUMN_VALUE(c,32,V32);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 33 then
	dbms_sql.COLUMN_VALUE(c,33,V33);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 34 then
	dbms_sql.COLUMN_VALUE(c,34,V34);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 35 then
	dbms_sql.COLUMN_VALUE(c,35,V35);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 36 then
	dbms_sql.COLUMN_VALUE(c,36,V36);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 37 then
	dbms_sql.COLUMN_VALUE(c,37,V37);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 38 then
	dbms_sql.COLUMN_VALUE(c,38,V38);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 39 then
	dbms_sql.COLUMN_VALUE(c,39,V39);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 40 then
	dbms_sql.COLUMN_VALUE(c,40,V40);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 41 then
	dbms_sql.COLUMN_VALUE(c,41,V41);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 42 then
	dbms_sql.COLUMN_VALUE(c,42,V42);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 43 then
	dbms_sql.COLUMN_VALUE(c,43,V43);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 44 then
	dbms_sql.COLUMN_VALUE(c,44,V44);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 45 then
	dbms_sql.COLUMN_VALUE(c,45,V45);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 46 then
	dbms_sql.COLUMN_VALUE(c,46,V46);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 47 then
	dbms_sql.COLUMN_VALUE(c,47,V47);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 48 then
	dbms_sql.COLUMN_VALUE(c,48,V48);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 49 then
	dbms_sql.COLUMN_VALUE(c,49,V49);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 50 then
	dbms_sql.COLUMN_VALUE(c,50,V50);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 51 then
	dbms_sql.COLUMN_VALUE(c,51,V51);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 52 then
	dbms_sql.COLUMN_VALUE(c,52,V52);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 53 then
	dbms_sql.COLUMN_VALUE(c,53,V53);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 54 then
	dbms_sql.COLUMN_VALUE(c,54,V54);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 55 then
	dbms_sql.COLUMN_VALUE(c,55,V55);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 56 then
	dbms_sql.COLUMN_VALUE(c,56,V56);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 57 then
	dbms_sql.COLUMN_VALUE(c,57,V57);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 58 then
	dbms_sql.COLUMN_VALUE(c,58,V58);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 59 then
	dbms_sql.COLUMN_VALUE(c,59,V59);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 60 then
	dbms_sql.COLUMN_VALUE(c,60,V60);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 61 then
	dbms_sql.COLUMN_VALUE(c,61,V61);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 62 then
	dbms_sql.COLUMN_VALUE(c,62,V62);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 63 then
	dbms_sql.COLUMN_VALUE(c,63,V63);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 64 then
	dbms_sql.COLUMN_VALUE(c,64,V64);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 65 then
	dbms_sql.COLUMN_VALUE(c,65,V65);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 66 then
	dbms_sql.COLUMN_VALUE(c,66,V66);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 67 then
	dbms_sql.COLUMN_VALUE(c,67,V67);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 68 then
	dbms_sql.COLUMN_VALUE(c,68,V68);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 69 then
	dbms_sql.COLUMN_VALUE(c,69,V69);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 70 then
	dbms_sql.COLUMN_VALUE(c,70,V70);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 71 then
	dbms_sql.COLUMN_VALUE(c,71,V71);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 72 then
	dbms_sql.COLUMN_VALUE(c,72,V72);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 73 then
	dbms_sql.COLUMN_VALUE(c,73,V73);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 74 then
	dbms_sql.COLUMN_VALUE(c,74,V74);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 75 then
	dbms_sql.COLUMN_VALUE(c,75,V75);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 76 then
	dbms_sql.COLUMN_VALUE(c,76,V76);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 77 then
	dbms_sql.COLUMN_VALUE(c,77,V77);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 78 then
	dbms_sql.COLUMN_VALUE(c,78,V78);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 79 then
	dbms_sql.COLUMN_VALUE(c,79,V79);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 80 then
	dbms_sql.COLUMN_VALUE(c,80,V80);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 81 then
	dbms_sql.COLUMN_VALUE(c,81,V81);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 82 then
	dbms_sql.COLUMN_VALUE(c,82,V82);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 83 then
	dbms_sql.COLUMN_VALUE(c,83,V83);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 84 then
	dbms_sql.COLUMN_VALUE(c,84,V84);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 85 then
	dbms_sql.COLUMN_VALUE(c,85,V85);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 86 then
	dbms_sql.COLUMN_VALUE(c,86,V86);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 87 then
	dbms_sql.COLUMN_VALUE(c,87,V87);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 88 then
	dbms_sql.COLUMN_VALUE(c,88,V88);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 89 then
	dbms_sql.COLUMN_VALUE(c,89,V89);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 90 then
	dbms_sql.COLUMN_VALUE(c,90,V90);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 91 then
	dbms_sql.COLUMN_VALUE(c,91,V91);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 92 then
	dbms_sql.COLUMN_VALUE(c,92,V92);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 93 then
	dbms_sql.COLUMN_VALUE(c,93,V93);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 94 then
	dbms_sql.COLUMN_VALUE(c,94,V94);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 95 then
	dbms_sql.COLUMN_VALUE(c,95,V95);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 96 then
	dbms_sql.COLUMN_VALUE(c,96,V96);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 97 then
	dbms_sql.COLUMN_VALUE(c,97,V97);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 98 then
	dbms_sql.COLUMN_VALUE(c,98,V98);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 99 then
	dbms_sql.COLUMN_VALUE(c,99,V99);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 100 then
	dbms_sql.COLUMN_VALUE(c,100,V100);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 101 then
	dbms_sql.COLUMN_VALUE(c,101,V101);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 102 then
	dbms_sql.COLUMN_VALUE(c,102,V102);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 103 then
	dbms_sql.COLUMN_VALUE(c,103,V103);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 104 then
	dbms_sql.COLUMN_VALUE(c,104,V104);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 105 then
	dbms_sql.COLUMN_VALUE(c,105,V105);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 106 then
	dbms_sql.COLUMN_VALUE(c,106,V106);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 107 then
	dbms_sql.COLUMN_VALUE(c,107,V107);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 108 then
	dbms_sql.COLUMN_VALUE(c,108,V108);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 109 then
	dbms_sql.COLUMN_VALUE(c,109,V109);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 110 then
	dbms_sql.COLUMN_VALUE(c,110,V110);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 111 then
	dbms_sql.COLUMN_VALUE(c,111,V111);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 112 then
	dbms_sql.COLUMN_VALUE(c,112,V112);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 113 then
	dbms_sql.COLUMN_VALUE(c,113,V113);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 114 then
	dbms_sql.COLUMN_VALUE(c,114,V114);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 115 then
	dbms_sql.COLUMN_VALUE(c,115,V115);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 116 then
	dbms_sql.COLUMN_VALUE(c,116,V116);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 117 then
	dbms_sql.COLUMN_VALUE(c,117,V117);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 118 then
	dbms_sql.COLUMN_VALUE(c,118,V118);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 119 then
	dbms_sql.COLUMN_VALUE(c,119,V119);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 120 then
	dbms_sql.COLUMN_VALUE(c,120,V120);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 121 then
	dbms_sql.COLUMN_VALUE(c,121,V121);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 122 then
	dbms_sql.COLUMN_VALUE(c,122,V122);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 123 then
	dbms_sql.COLUMN_VALUE(c,123,V123);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 124 then
	dbms_sql.COLUMN_VALUE(c,124,V124);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 125 then
	dbms_sql.COLUMN_VALUE(c,125,V125);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 126 then
	dbms_sql.COLUMN_VALUE(c,126,V126);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 127 then
	dbms_sql.COLUMN_VALUE(c,127,V127);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 128 then
	dbms_sql.COLUMN_VALUE(c,128,V128);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 129 then
	dbms_sql.COLUMN_VALUE(c,129,V129);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 130 then
	dbms_sql.COLUMN_VALUE(c,130,V130);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 131 then
	dbms_sql.COLUMN_VALUE(c,131,V131);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 132 then
	dbms_sql.COLUMN_VALUE(c,132,V132);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 133 then
	dbms_sql.COLUMN_VALUE(c,133,V133);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 134 then
	dbms_sql.COLUMN_VALUE(c,134,V134);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 135 then
	dbms_sql.COLUMN_VALUE(c,135,V135);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 136 then
	dbms_sql.COLUMN_VALUE(c,136,V136);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 137 then
	dbms_sql.COLUMN_VALUE(c,137,V137);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 138 then
	dbms_sql.COLUMN_VALUE(c,138,V138);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 139 then
	dbms_sql.COLUMN_VALUE(c,139,V139);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 140 then
	dbms_sql.COLUMN_VALUE(c,140,V140);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 141 then
	dbms_sql.COLUMN_VALUE(c,141,V141);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 142 then
	dbms_sql.COLUMN_VALUE(c,142,V142);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 143 then
	dbms_sql.COLUMN_VALUE(c,143,V143);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 144 then
	dbms_sql.COLUMN_VALUE(c,144,V144);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 145 then
	dbms_sql.COLUMN_VALUE(c,145,V145);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 146 then
	dbms_sql.COLUMN_VALUE(c,146,V146);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 147 then
	dbms_sql.COLUMN_VALUE(c,147,V147);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 148 then
	dbms_sql.COLUMN_VALUE(c,148,V148);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 149 then
	dbms_sql.COLUMN_VALUE(c,149,V149);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 150 then
	dbms_sql.COLUMN_VALUE(c,150,V150);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 151 then
	dbms_sql.COLUMN_VALUE(c,151,V151);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 152 then
	dbms_sql.COLUMN_VALUE(c,152,V152);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 153 then
	dbms_sql.COLUMN_VALUE(c,153,V153);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 154 then
	dbms_sql.COLUMN_VALUE(c,154,V154);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 155 then
	dbms_sql.COLUMN_VALUE(c,155,V155);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 156 then
	dbms_sql.COLUMN_VALUE(c,156,V156);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 157 then
	dbms_sql.COLUMN_VALUE(c,157,V157);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 158 then
	dbms_sql.COLUMN_VALUE(c,158,V158);
	l_pos := l_pos + 1;
	-- dbms_output.put_line ('Got ' || l_pos);
ELSE
	RETURN;
end if;
if N_COLS >= 159 then
	dbms_sql.COLUMN_VALUE(c,159,V159);
ELSE
	RETURN;
end if;
if N_COLS >= 160 then
	dbms_sql.COLUMN_VALUE(c,160,V160);
ELSE
	RETURN;
end if;
if N_COLS >= 161 then
	dbms_sql.COLUMN_VALUE(c,161,V161);
ELSE
	RETURN;
end if;
if N_COLS >= 162 then
	dbms_sql.COLUMN_VALUE(c,162,V162);
ELSE
	RETURN;
end if;
if N_COLS >= 163 then
	dbms_sql.COLUMN_VALUE(c,163,V163);
ELSE
	RETURN;
end if;
if N_COLS >= 164 then
	dbms_sql.COLUMN_VALUE(c,164,V164);
ELSE
	RETURN;
end if;
if N_COLS >= 165 then
	dbms_sql.COLUMN_VALUE(c,165,V165);
ELSE
	RETURN;
end if;
if N_COLS >= 166 then
	dbms_sql.COLUMN_VALUE(c,166,V166);
ELSE
	RETURN;
end if;
if N_COLS >= 167 then
	dbms_sql.COLUMN_VALUE(c,167,V167);
ELSE
	RETURN;
end if;
if N_COLS >= 168 then
	dbms_sql.COLUMN_VALUE(c,168,V168);
ELSE
	RETURN;
end if;
if N_COLS >= 169 then
	dbms_sql.COLUMN_VALUE(c,169,V169);
ELSE
	RETURN;
end if;
if N_COLS >= 170 then
	dbms_sql.COLUMN_VALUE(c,170,V170);
ELSE
	RETURN;
end if;
if N_COLS >= 171 then
	dbms_sql.COLUMN_VALUE(c,171,V171);
ELSE
	RETURN;
end if;
if N_COLS >= 172 then
	dbms_sql.COLUMN_VALUE(c,172,V172);
ELSE
	RETURN;
end if;
if N_COLS >= 173 then
	dbms_sql.COLUMN_VALUE(c,173,V173);
ELSE
	RETURN;
end if;
if N_COLS >= 174 then
	dbms_sql.COLUMN_VALUE(c,174,V174);
ELSE
	RETURN;
end if;
if N_COLS >= 175 then
	dbms_sql.COLUMN_VALUE(c,175,V175);
ELSE
	RETURN;
end if;
if N_COLS >= 176 then
	dbms_sql.COLUMN_VALUE(c,176,V176);
ELSE
	RETURN;
end if;
if N_COLS >= 177 then
	dbms_sql.COLUMN_VALUE(c,177,V177);
ELSE
	RETURN;
end if;
if N_COLS >= 178 then
	dbms_sql.COLUMN_VALUE(c,178,V178);
ELSE
	RETURN;
end if;
if N_COLS >= 179 then
	dbms_sql.COLUMN_VALUE(c,179,V179);
ELSE
	RETURN;
end if;
if N_COLS >= 180 then
	dbms_sql.COLUMN_VALUE(c,180,V180);
ELSE
	RETURN;
end if;
if N_COLS >= 181 then
	dbms_sql.COLUMN_VALUE(c,181,V181);
ELSE
	RETURN;
end if;
if N_COLS >= 182 then
	dbms_sql.COLUMN_VALUE(c,182,V182);
ELSE
	RETURN;
end if;
if N_COLS >= 183 then
	dbms_sql.COLUMN_VALUE(c,183,V183);
ELSE
	RETURN;
end if;
if N_COLS >= 184 then
	dbms_sql.COLUMN_VALUE(c,184,V184);
ELSE
	RETURN;
end if;
if N_COLS >= 185 then
	dbms_sql.COLUMN_VALUE(c,185,V185);
ELSE
	RETURN;
end if;
if N_COLS >= 186 then
	dbms_sql.COLUMN_VALUE(c,186,V186);
ELSE
	RETURN;
end if;
if N_COLS >= 187 then
	dbms_sql.COLUMN_VALUE(c,187,V187);
ELSE
	RETURN;
end if;
if N_COLS >= 188 then
	dbms_sql.COLUMN_VALUE(c,188,V188);
ELSE
	RETURN;
end if;
if N_COLS >= 189 then
	dbms_sql.COLUMN_VALUE(c,189,V189);
ELSE
	RETURN;
end if;
if N_COLS >= 190 then
	dbms_sql.COLUMN_VALUE(c,190,V190);
ELSE
	RETURN;
end if;
if N_COLS >= 191 then
	dbms_sql.COLUMN_VALUE(c,191,V191);
ELSE
	RETURN;
end if;
if N_COLS >= 192 then
	dbms_sql.COLUMN_VALUE(c,192,V192);
ELSE
	RETURN;
end if;
/*
if N_COLS >= 193 then
	dbms_sql.COLUMN_VALUE(c,193,V193);
ELSE
	RETURN;
end if;
if N_COLS >= 194 then
	dbms_sql.COLUMN_VALUE(c,194,V194);
ELSE
	RETURN;
end if;
if N_COLS >= 195 then
	dbms_sql.COLUMN_VALUE(c,195,V195);
ELSE
	RETURN;
end if;
if N_COLS >= 196 then
	dbms_sql.COLUMN_VALUE(c,196,V196);
ELSE
	RETURN;
end if;
if N_COLS >= 197 then
	dbms_sql.COLUMN_VALUE(c,197,V197);
ELSE
	RETURN;
end if;
if N_COLS >= 198 then
	dbms_sql.COLUMN_VALUE(c,198,V198);
ELSE
	RETURN;
end if;
if N_COLS >= 199 then
	dbms_sql.COLUMN_VALUE(c,199,V199);
ELSE
	RETURN;
end if;
if N_COLS >= 200 then
	dbms_sql.COLUMN_VALUE(c,200,V200);
ELSE
	RETURN;
end if;
if N_COLS >= 201 then
	dbms_sql.COLUMN_VALUE(c,201,V201);
ELSE
	RETURN;
end if;
if N_COLS >= 202 then
	dbms_sql.COLUMN_VALUE(c,202,V202);
ELSE
	RETURN;
end if;
if N_COLS >= 203 then
	dbms_sql.COLUMN_VALUE(c,203,V203);
ELSE
	RETURN;
end if;
if N_COLS >= 204 then
	dbms_sql.COLUMN_VALUE(c,204,V204);
ELSE
	RETURN;
end if;
if N_COLS >= 205 then
	dbms_sql.COLUMN_VALUE(c,205,V205);
ELSE
	RETURN;
end if;
if N_COLS >= 206 then
	dbms_sql.COLUMN_VALUE(c,206,V206);
ELSE
	RETURN;
end if;
if N_COLS >= 207 then
	dbms_sql.COLUMN_VALUE(c,207,V207);
ELSE
	RETURN;
end if;
if N_COLS >= 208 then
	dbms_sql.COLUMN_VALUE(c,208,V208);
ELSE
	RETURN;
end if;
if N_COLS >= 209 then
	dbms_sql.COLUMN_VALUE(c,209,V209);
ELSE
	RETURN;
end if;
if N_COLS >= 210 then
	dbms_sql.COLUMN_VALUE(c,210,V210);
ELSE
	RETURN;
end if;
if N_COLS >= 211 then
	dbms_sql.COLUMN_VALUE(c,211,V211);
ELSE
	RETURN;
end if;
if N_COLS >= 212 then
	dbms_sql.COLUMN_VALUE(c,212,V212);
ELSE
	RETURN;
end if;
if N_COLS >= 213 then
	dbms_sql.COLUMN_VALUE(c,213,V213);
ELSE
	RETURN;
end if;
if N_COLS >= 214 then
	dbms_sql.COLUMN_VALUE(c,214,V214);
ELSE
	RETURN;
end if;
if N_COLS >= 215 then
	dbms_sql.COLUMN_VALUE(c,215,V215);
ELSE
	RETURN;
end if;
if N_COLS >= 216 then
	dbms_sql.COLUMN_VALUE(c,216,V216);
ELSE
	RETURN;
end if;
if N_COLS >= 217 then
	dbms_sql.COLUMN_VALUE(c,217,V217);
ELSE
	RETURN;
end if;
if N_COLS >= 218 then
	dbms_sql.COLUMN_VALUE(c,218,V218);
ELSE
	RETURN;
end if;
if N_COLS >= 219 then
	dbms_sql.COLUMN_VALUE(c,219,V219);
ELSE
	RETURN;
end if;
if N_COLS >= 220 then
	dbms_sql.COLUMN_VALUE(c,220,V220);
ELSE
	RETURN;
end if;
if N_COLS >= 221 then
	dbms_sql.COLUMN_VALUE(c,221,V221);
ELSE
	RETURN;
end if;
if N_COLS >= 222 then
	dbms_sql.COLUMN_VALUE(c,222,V222);
ELSE
	RETURN;
end if;
if N_COLS >= 223 then
	dbms_sql.COLUMN_VALUE(c,223,V223);
ELSE
	RETURN;
end if;
if N_COLS >= 224 then
	dbms_sql.COLUMN_VALUE(c,224,V224);
ELSE
	RETURN;
end if;
if N_COLS >= 225 then
	dbms_sql.COLUMN_VALUE(c,225,V225);
ELSE
	RETURN;
end if;
if N_COLS >= 226 then
	dbms_sql.COLUMN_VALUE(c,226,V226);
ELSE
	RETURN;
end if;
if N_COLS >= 227 then
	dbms_sql.COLUMN_VALUE(c,227,V227);
ELSE
	RETURN;
end if;
if N_COLS >= 228 then
	dbms_sql.COLUMN_VALUE(c,228,V228);
ELSE
	RETURN;
end if;
if N_COLS >= 229 then
	dbms_sql.COLUMN_VALUE(c,229,V229);
ELSE
	RETURN;
end if;
if N_COLS >= 230 then
	dbms_sql.COLUMN_VALUE(c,230,V230);
ELSE
	RETURN;
end if;
if N_COLS >= 231 then
	dbms_sql.COLUMN_VALUE(c,231,V231);
ELSE
	RETURN;
end if;
if N_COLS >= 232 then
	dbms_sql.COLUMN_VALUE(c,232,V232);
ELSE
	RETURN;
end if;
if N_COLS >= 233 then
	dbms_sql.COLUMN_VALUE(c,233,V233);
ELSE
	RETURN;
end if;
if N_COLS >= 234 then
	dbms_sql.COLUMN_VALUE(c,234,V234);
ELSE
	RETURN;
end if;
if N_COLS >= 235 then
	dbms_sql.COLUMN_VALUE(c,235,V235);
ELSE
	RETURN;
end if;
if N_COLS >= 236 then
	dbms_sql.COLUMN_VALUE(c,236,V236);
ELSE
	RETURN;
end if;
if N_COLS >= 237 then
	dbms_sql.COLUMN_VALUE(c,237,V237);
ELSE
	RETURN;
end if;
if N_COLS >= 238 then
	dbms_sql.COLUMN_VALUE(c,238,V238);
ELSE
	RETURN;
end if;
if N_COLS >= 239 then
	dbms_sql.COLUMN_VALUE(c,239,V239);
ELSE
	RETURN;
end if;
if N_COLS >= 240 then
	dbms_sql.COLUMN_VALUE(c,240,V240);
ELSE
	RETURN;
end if;
if N_COLS >= 241 then
	dbms_sql.COLUMN_VALUE(c,241,V241);
ELSE
	RETURN;
end if;
if N_COLS >= 242 then
	dbms_sql.COLUMN_VALUE(c,242,V242);
ELSE
	RETURN;
end if;
if N_COLS >= 243 then
	dbms_sql.COLUMN_VALUE(c,243,V243);
ELSE
	RETURN;
end if;
if N_COLS >= 244 then
	dbms_sql.COLUMN_VALUE(c,244,V244);
ELSE
	RETURN;
end if;
if N_COLS >= 245 then
	dbms_sql.COLUMN_VALUE(c,245,V245);
ELSE
	RETURN;
end if;
if N_COLS >= 246 then
	dbms_sql.COLUMN_VALUE(c,246,V246);
ELSE
	RETURN;
end if;
if N_COLS >= 247 then
	dbms_sql.COLUMN_VALUE(c,247,V247);
ELSE
	RETURN;
end if;
if N_COLS >= 248 then
	dbms_sql.COLUMN_VALUE(c,248,V248);
ELSE
	RETURN;
end if;
if N_COLS >= 249 then
	dbms_sql.COLUMN_VALUE(c,249,V249);
ELSE
	RETURN;
end if;
if N_COLS >= 250 then
	dbms_sql.COLUMN_VALUE(c,250,V250);
ELSE
	RETURN;
end if;
if N_COLS >= 251 then
	dbms_sql.COLUMN_VALUE(c,251,V251);
ELSE
	RETURN;
end if;
if N_COLS >= 252 then
	dbms_sql.COLUMN_VALUE(c,252,V252);
ELSE
	RETURN;
end if;
if N_COLS >= 253 then
	dbms_sql.COLUMN_VALUE(c,253,V253);
ELSE
	RETURN;
end if;
if N_COLS >= 254 then
	dbms_sql.COLUMN_VALUE(c,254,V254);
ELSE
	RETURN;
end if;
if N_COLS >= 255 then
	dbms_sql.COLUMN_VALUE(c,255,V255);
ELSE
	RETURN;
end if;
*/
exception
	when others then
		-- utl_file.put_line(f,'COL VALUES');
		-- utl_file.put_line(f,sqlerrm);
		raise;
end column_values;
function get_cur_val(cur_row integer,cur_col integer) return varchar2
is
	cur_fld VARCHAR2(32767);
	p integer;
begin
if CUR_COL = 1 then
	cur_fld := V1;
elsif CUR_COL = 2 then
	cur_fld := V2;
elsif CUR_COL = 3 then
	cur_fld := V3;
elsif CUR_COL = 4 then
	cur_fld := V4;
elsif CUR_COL = 5 then
	cur_fld := V5;
elsif CUR_COL = 6 then
	cur_fld := V6;
elsif CUR_COL = 7 then
	cur_fld := V7;
elsif CUR_COL = 8 then
	cur_fld := V8;
elsif CUR_COL = 9 then
	cur_fld := V9;
elsif CUR_COL = 10 then
	cur_fld := V10;
elsif CUR_COL = 11 then
	cur_fld := V11;
elsif CUR_COL = 12 then
	cur_fld := V12;
elsif CUR_COL = 13 then
	cur_fld := V13;
elsif CUR_COL = 14 then
	cur_fld := V14;
elsif CUR_COL = 15 then
	cur_fld := V15;
elsif CUR_COL = 16 then
	cur_fld := V16;
elsif CUR_COL = 17 then
	cur_fld := V17;
elsif CUR_COL = 18 then
	cur_fld := V18;
elsif CUR_COL = 19 then
	cur_fld := V19;
elsif CUR_COL = 20 then
	cur_fld := V20;
elsif CUR_COL = 21 then
	cur_fld := V21;
elsif CUR_COL = 22 then
	cur_fld := V22;
elsif CUR_COL = 23 then
	cur_fld := V23;
elsif CUR_COL = 24 then
	cur_fld := V24;
elsif CUR_COL = 25 then
	cur_fld := V25;
elsif CUR_COL = 26 then
	cur_fld := V26;
elsif CUR_COL = 27 then
	cur_fld := V27;
elsif CUR_COL = 28 then
	cur_fld := V28;
elsif CUR_COL = 29 then
	cur_fld := V29;
elsif CUR_COL = 30 then
	cur_fld := V30;
elsif CUR_COL = 31 then
	cur_fld := V31;
elsif CUR_COL = 32 then
	cur_fld := V32;
elsif CUR_COL = 33 then
	cur_fld := V33;
elsif CUR_COL = 34 then
	cur_fld := V34;
elsif CUR_COL = 35 then
	cur_fld := V35;
elsif CUR_COL = 36 then
	cur_fld := V36;
elsif CUR_COL = 37 then
	cur_fld := V37;
elsif CUR_COL = 38 then
	cur_fld := V38;
elsif CUR_COL = 39 then
	cur_fld := V39;
elsif CUR_COL = 40 then
	cur_fld := V40;
elsif CUR_COL = 41 then
	cur_fld := V41;
elsif CUR_COL = 42 then
	cur_fld := V42;
elsif CUR_COL = 43 then
	cur_fld := V43;
elsif CUR_COL = 44 then
	cur_fld := V44;
elsif CUR_COL = 45 then
	cur_fld := V45;
elsif CUR_COL = 46 then
	cur_fld := V46;
elsif CUR_COL = 47 then
	cur_fld := V47;
elsif CUR_COL = 48 then
	cur_fld := V48;
elsif CUR_COL = 49 then
	cur_fld := V49;
elsif CUR_COL = 50 then
	cur_fld := V50;
elsif CUR_COL = 51 then
	cur_fld := V51;
elsif CUR_COL = 52 then
	cur_fld := V52;
elsif CUR_COL = 53 then
	cur_fld := V53;
elsif CUR_COL = 54 then
	cur_fld := V54;
elsif CUR_COL = 55 then
	cur_fld := V55;
elsif CUR_COL = 56 then
	cur_fld := V56;
elsif CUR_COL = 57 then
	cur_fld := V57;
elsif CUR_COL = 58 then
	cur_fld := V58;
elsif CUR_COL = 59 then
	cur_fld := V59;
elsif CUR_COL = 60 then
	cur_fld := V60;
elsif CUR_COL = 61 then
	cur_fld := V61;
elsif CUR_COL = 62 then
	cur_fld := V62;
elsif CUR_COL = 63 then
	cur_fld := V63;
elsif CUR_COL = 64 then
	cur_fld := V64;
elsif CUR_COL = 65 then
	cur_fld := V65;
elsif CUR_COL = 66 then
	cur_fld := V66;
elsif CUR_COL = 67 then
	cur_fld := V67;
elsif CUR_COL = 68 then
	cur_fld := V68;
elsif CUR_COL = 69 then
	cur_fld := V69;
elsif CUR_COL = 70 then
	cur_fld := V70;
elsif CUR_COL = 71 then
	cur_fld := V71;
elsif CUR_COL = 72 then
	cur_fld := V72;
elsif CUR_COL = 73 then
	cur_fld := V73;
elsif CUR_COL = 74 then
	cur_fld := V74;
elsif CUR_COL = 75 then
	cur_fld := V75;
elsif CUR_COL = 76 then
	cur_fld := V76;
elsif CUR_COL = 77 then
	cur_fld := V77;
elsif CUR_COL = 78 then
	cur_fld := V78;
elsif CUR_COL = 79 then
	cur_fld := V79;
elsif CUR_COL = 80 then
	cur_fld := V80;
elsif CUR_COL = 81 then
	cur_fld := V81;
elsif CUR_COL = 82 then
	cur_fld := V82;
elsif CUR_COL = 83 then
	cur_fld := V83;
elsif CUR_COL = 84 then
	cur_fld := V84;
elsif CUR_COL = 85 then
	cur_fld := V85;
elsif CUR_COL = 86 then
	cur_fld := V86;
elsif CUR_COL = 87 then
	cur_fld := V87;
elsif CUR_COL = 88 then
	cur_fld := V88;
elsif CUR_COL = 89 then
	cur_fld := V89;
elsif CUR_COL = 90 then
	cur_fld := V90;
elsif CUR_COL = 91 then
	cur_fld := V91;
elsif CUR_COL = 92 then
	cur_fld := V92;
elsif CUR_COL = 93 then
	cur_fld := V93;
elsif CUR_COL = 94 then
	cur_fld := V94;
elsif CUR_COL = 95 then
	cur_fld := V95;
elsif CUR_COL = 96 then
	cur_fld := V96;
elsif CUR_COL = 97 then
	cur_fld := V97;
elsif CUR_COL = 98 then
	cur_fld := V98;
elsif CUR_COL = 99 then
	cur_fld := V99;
elsif CUR_COL = 100 then
	cur_fld := V100;
elsif CUR_COL = 101 then
	cur_fld := V101;
elsif CUR_COL = 102 then
	cur_fld := V102;
elsif CUR_COL = 103 then
	cur_fld := V103;
elsif CUR_COL = 104 then
	cur_fld := V104;
elsif CUR_COL = 105 then
	cur_fld := V105;
elsif CUR_COL = 106 then
	cur_fld := V106;
elsif CUR_COL = 107 then
	cur_fld := V107;
elsif CUR_COL = 108 then
	cur_fld := V108;
elsif CUR_COL = 109 then
	cur_fld := V109;
elsif CUR_COL = 110 then
	cur_fld := V110;
elsif CUR_COL = 111 then
	cur_fld := V111;
elsif CUR_COL = 112 then
	cur_fld := V112;
elsif CUR_COL = 113 then
	cur_fld := V113;
elsif CUR_COL = 114 then
	cur_fld := V114;
elsif CUR_COL = 115 then
	cur_fld := V115;
elsif CUR_COL = 116 then
	cur_fld := V116;
elsif CUR_COL = 117 then
	cur_fld := V117;
elsif CUR_COL = 118 then
	cur_fld := V118;
elsif CUR_COL = 119 then
	cur_fld := V119;
elsif CUR_COL = 120 then
	cur_fld := V120;
elsif CUR_COL = 121 then
	cur_fld := V121;
elsif CUR_COL = 122 then
	cur_fld := V122;
elsif CUR_COL = 123 then
	cur_fld := V123;
elsif CUR_COL = 124 then
	cur_fld := V124;
elsif CUR_COL = 125 then
	cur_fld := V125;
elsif CUR_COL = 126 then
	cur_fld := V126;
elsif CUR_COL = 127 then
	cur_fld := V127;
elsif CUR_COL = 128 then
	cur_fld := V128;
elsif CUR_COL = 129 then
	cur_fld := V129;
elsif CUR_COL = 130 then
	cur_fld := V130;
elsif CUR_COL = 131 then
	cur_fld := V131;
elsif CUR_COL = 132 then
	cur_fld := V132;
elsif CUR_COL = 133 then
	cur_fld := V133;
elsif CUR_COL = 134 then
	cur_fld := V134;
elsif CUR_COL = 135 then
	cur_fld := V135;
elsif CUR_COL = 136 then
	cur_fld := V136;
elsif CUR_COL = 137 then
	cur_fld := V137;
elsif CUR_COL = 138 then
	cur_fld := V138;
elsif CUR_COL = 139 then
	cur_fld := V139;
elsif CUR_COL = 140 then
	cur_fld := V140;
elsif CUR_COL = 141 then
	cur_fld := V141;
elsif CUR_COL = 142 then
	cur_fld := V142;
elsif CUR_COL = 143 then
	cur_fld := V143;
elsif CUR_COL = 144 then
	cur_fld := V144;
elsif CUR_COL = 145 then
	cur_fld := V145;
elsif CUR_COL = 146 then
	cur_fld := V146;
elsif CUR_COL = 147 then
	cur_fld := V147;
elsif CUR_COL = 148 then
	cur_fld := V148;
elsif CUR_COL = 149 then
	cur_fld := V149;
elsif CUR_COL = 150 then
	cur_fld := V150;
elsif CUR_COL = 151 then
	cur_fld := V151;
elsif CUR_COL = 152 then
	cur_fld := V152;
elsif CUR_COL = 153 then
	cur_fld := V153;
elsif CUR_COL = 154 then
	cur_fld := V154;
elsif CUR_COL = 155 then
	cur_fld := V155;
elsif CUR_COL = 156 then
	cur_fld := V156;
elsif CUR_COL = 157 then
	cur_fld := V157;
elsif CUR_COL = 158 then
	cur_fld := V158;
elsif CUR_COL = 159 then
	cur_fld := V159;
elsif CUR_COL = 160 then
	cur_fld := V160;
elsif CUR_COL = 161 then
	cur_fld := V161;
elsif CUR_COL = 162 then
	cur_fld := V162;
elsif CUR_COL = 163 then
	cur_fld := V163;
elsif CUR_COL = 164 then
	cur_fld := V164;
elsif CUR_COL = 165 then
	cur_fld := V165;
elsif CUR_COL = 166 then
	cur_fld := V166;
elsif CUR_COL = 167 then
	cur_fld := V167;
elsif CUR_COL = 168 then
	cur_fld := V168;
elsif CUR_COL = 169 then
	cur_fld := V169;
elsif CUR_COL = 170 then
	cur_fld := V170;
elsif CUR_COL = 171 then
	cur_fld := V171;
elsif CUR_COL = 172 then
	cur_fld := V172;
elsif CUR_COL = 173 then
	cur_fld := V173;
elsif CUR_COL = 174 then
	cur_fld := V174;
elsif CUR_COL = 175 then
	cur_fld := V175;
elsif CUR_COL = 176 then
	cur_fld := V176;
elsif CUR_COL = 177 then
	cur_fld := V177;
elsif CUR_COL = 178 then
	cur_fld := V178;
elsif CUR_COL = 179 then
	cur_fld := V179;
elsif CUR_COL = 180 then
	cur_fld := V180;
elsif CUR_COL = 181 then
	cur_fld := V181;
elsif CUR_COL = 182 then
	cur_fld := V182;
elsif CUR_COL = 183 then
	cur_fld := V183;
elsif CUR_COL = 184 then
	cur_fld := V184;
elsif CUR_COL = 185 then
	cur_fld := V185;
elsif CUR_COL = 186 then
	cur_fld := V186;
elsif CUR_COL = 187 then
	cur_fld := V187;
elsif CUR_COL = 188 then
	cur_fld := V188;
elsif CUR_COL = 189 then
	cur_fld := V189;
elsif CUR_COL = 190 then
	cur_fld := V190;
elsif CUR_COL = 191 then
	cur_fld := V191;
elsif CUR_COL = 192 then
	cur_fld := V192;
/*
elsif CUR_COL = 193 then
	cur_fld := V193;
elsif CUR_COL = 194 then
	cur_fld := V194;
elsif CUR_COL = 195 then
	cur_fld := V195;
elsif CUR_COL = 196 then
	cur_fld := V196;
elsif CUR_COL = 197 then
	cur_fld := V197;
elsif CUR_COL = 198 then
	cur_fld := V198;
elsif CUR_COL = 199 then
	cur_fld := V199;
elsif CUR_COL = 200 then
	cur_fld := V200;
elsif CUR_COL = 201 then
	cur_fld := V201;
elsif CUR_COL = 202 then
	cur_fld := V202;
elsif CUR_COL = 203 then
	cur_fld := V203;
elsif CUR_COL = 204 then
	cur_fld := V204;
elsif CUR_COL = 205 then
	cur_fld := V205;
elsif CUR_COL = 206 then
	cur_fld := V206;
elsif CUR_COL = 207 then
	cur_fld := V207;
elsif CUR_COL = 208 then
	cur_fld := V208;
elsif CUR_COL = 209 then
	cur_fld := V209;
elsif CUR_COL = 210 then
	cur_fld := V210;
elsif CUR_COL = 211 then
	cur_fld := V211;
elsif CUR_COL = 212 then
	cur_fld := V212;
elsif CUR_COL = 213 then
	cur_fld := V213;
elsif CUR_COL = 214 then
	cur_fld := V214;
elsif CUR_COL = 215 then
	cur_fld := V215;
elsif CUR_COL = 216 then
	cur_fld := V216;
elsif CUR_COL = 217 then
	cur_fld := V217;
elsif CUR_COL = 218 then
	cur_fld := V218;
elsif CUR_COL = 219 then
	cur_fld := V219;
elsif CUR_COL = 220 then
	cur_fld := V220;
elsif CUR_COL = 221 then
	cur_fld := V221;
elsif CUR_COL = 222 then
	cur_fld := V222;
elsif CUR_COL = 223 then
	cur_fld := V223;
elsif CUR_COL = 224 then
	cur_fld := V224;
elsif CUR_COL = 225 then
	cur_fld := V225;
elsif CUR_COL = 226 then
	cur_fld := V226;
elsif CUR_COL = 227 then
	cur_fld := V227;
elsif CUR_COL = 228 then
	cur_fld := V228;
elsif CUR_COL = 229 then
	cur_fld := V229;
elsif CUR_COL = 230 then
	cur_fld := V230;
elsif CUR_COL = 231 then
	cur_fld := V231;
elsif CUR_COL = 232 then
	cur_fld := V232;
elsif CUR_COL = 233 then
	cur_fld := V233;
elsif CUR_COL = 234 then
	cur_fld := V234;
elsif CUR_COL = 235 then
	cur_fld := V235;
elsif CUR_COL = 236 then
	cur_fld := V236;
elsif CUR_COL = 237 then
	cur_fld := V237;
elsif CUR_COL = 238 then
	cur_fld := V238;
elsif CUR_COL = 239 then
	cur_fld := V239;
elsif CUR_COL = 240 then
	cur_fld := V240;
elsif CUR_COL = 241 then
	cur_fld := V241;
elsif CUR_COL = 242 then
	cur_fld := V242;
elsif CUR_COL = 243 then
	cur_fld := V243;
elsif CUR_COL = 244 then
	cur_fld := V244;
elsif CUR_COL = 245 then
	cur_fld := V245;
elsif CUR_COL = 246 then
	cur_fld := V246;
elsif CUR_COL = 247 then
	cur_fld := V247;
elsif CUR_COL = 248 then
	cur_fld := V248;
elsif CUR_COL = 249 then
	cur_fld := V249;
elsif CUR_COL = 250 then
	cur_fld := V250;
elsif CUR_COL = 251 then
	cur_fld := V251;
elsif CUR_COL = 252 then
	cur_fld := V252;
elsif CUR_COL = 253 then
	cur_fld := V253;
elsif CUR_COL = 254 then
	cur_fld := V254;
elsif CUR_COL = 255 then
	cur_fld := V255;
*/
end if;
	-- utl_file.put_line(f,'Field ' || cur_col || ' = ' || cur_fld);
	IF COL_TAB(CUR_COL).DATA_TYPE = 'DATE' THEN
		IF CUR_FLD IS NULL THEN
			CUR_FLD := 'TO_DATE(NULL)';
		ELSE
		CUR_FLD := 'TO_DATE(' || CHR(39) || TO_CHAR(to_date(CUR_FLD),'RRRRMMDDHH24MISS')
		          || CHR(39) || ','
				  || CHR(39) || 'RRRRMMDDHH24MISS' || CHR(39) ||
					    ')';
		END IF;
	ELSIF COL_TAB(CUR_COL).DATA_TYPE IN ('CHAR','VARCHAR2','LONG')
	THEN -- STRIP QUOTES
		P := INSTR(CUR_FLD,CHR(39));
		IF P <> 0 THEN
			-- utl_file.put_line(f,'Removing Quotes from ' || p || ' '|| length(cur_fld));
			CUR_FLD := replace(CUR_FLD,CHR(39),chr(39)||chr(39));
			-- utl_file.put_line(f,cur_fld);
		END IF;
		-- NOW REPLACE NEWLINES
		CUR_FLD := REPLACE(CUR_FLD,CHR(10),CHR(39) || '|| CHR(10) ||' ||
		chr(10) || chr(39));
		IF CUR_FLD IS NULL THEN
			CUR_FLD := 'NULL';
		ELSE
			CUR_FLD := CHR(39) || CUR_FLD || CHR(39);
		END IF;
	ELSIF COL_TAB(CUR_COL).DATA_TYPE != 'NUMBER' THEN
		IF CUR_FLD IS NULL THEN
			CUR_FLD := 'NULL';
		ELSE
			CUR_FLD := CHR(39) || CUR_FLD || CHR(39);
		END IF;
	ELSE
		IF CUR_FLD IS NULL THEN
			CUR_FLD := 'NULL';
		END IF;
	END IF;
	IF CUR_COL != 1 THEN
		CUR_FLD := ',' || CUR_FLD ;
	END IF;
	RETURN CUR_FLD;
exception
	when others then
		-- utl_file.put_line(f,'GET FIELD');
		-- utl_file.put_line(f,sqlerrm);
		raise;
end GET_CUR_VAL;
procedure append_array(cur_fld varchar2) is
	l integer;
begin
	l := length(cur_fld)+1;
	if l + sbuf_len > 32767 then
		utl_file.put(f,outbuff);
		utl_file.fflush(f);
		outbuff := cur_fld;
		sbuf_len := l;
	else
		outbuff := outbuff || cur_fld || chr(10);
		sbuf_len := sbuf_len+l;
	end if;
end append_array;
begin
	-- SG Support 20100423 start
	BEGIN
		select 	value into dt_fmt 
		from 	v$nls_parameters
		where 	parameter = 'NLS_DATE_FORMAT';
	EXCEPTION
	WHEN OTHERS
	THEN
		dt_fmt:= 'DD-MON-RR';
	END;	
	
	-- dt_fmt := global.get_nls_dt_format;	-- SG Support 20100423 end;
	
	-- dbms_output.put_line(dt_fmt);
	
	dbms_session.set_nls('NLS_DATE_FORMAT','YYYYMMDDHH24MISS');
	table_name := ltrim(rtrim(upper(t)));
	frame_query(table_name,ltrim(rtrim(w)));
	-- utl_file.put_line(f,query_str);
	if n_cols > 0 then
		c := dbms_sql.open_cursor;
		-- dbms_output.put_line('BEFORE PARSE');
		dbms_sql.parse(c,query_str,dbms_sql.native);
		-- dbms_output.put_line('BEFORE DEFINE');
		define_arrays(c,n_cols);
		-- dbms_output.put_line('BEFORE EXECUTE');
		i := dbms_sql.execute(c);
		loop
			-- dbms_output.put_line('BEFORE FETCH');
			i := dbms_sql.fetch_rows(c);
			-- UTL_FILE.PUT_LINE(F,'I GOT ' || I);
			-- dbms_output.put_line ('I GOT ' || I);
			if i = 0 then
				exit;
			else
			       -- dbms_output.put_line('BEFORE COL VAL');
				column_values(c,n_cols);
				append_array(insert_base);
				for k in 1..n_cols loop
					-- dbms_output.put_line ('Getting value #' || k);
					cur_fld := get_cur_val(1,k);
					append_array(cur_fld);
				end loop; -- k : all columns
				append_array(');' || chr(10) );
			end if;
		end loop; -- all rows in table;
		dbms_sql.close_cursor(c);
		if sbuf_len > 0 then
			-- dbms_output.put_line ('Length is ' || sbuf_len);
			utl_file.put_line (f,outbuff);
			utl_file.fflush(f);
		end if;
		utl_file.put_line(f,'PROMPT Completed ' || table_name);
		utl_file.fclose(f); -- Close will do a flush;
	end if; -- Col Check
	-- Amazingly a second dbms_session.set_nls does not work
	-- so have reset date format the hard way	.
	c := dbms_sql.open_cursor;
	dbms_sql.parse(c,'alter session set nls_date_format=' ||
	                 chr(39) || dt_fmt || chr(39),DBMS_SQL.NATIVE);
	i := dbms_sql.execute(c);
	dbms_sql.close_cursor(c);
exception
	when others then
		if utl_file.is_open(f) then
			utl_file.fclose(f);
		end if;
		IF DBMS_SQL.IS_OPEN(C) THEN
			DBMS_SQL.CLOSE_CURSOR(C);
		END IF;
		-- dbms_output.put_line('AFTER BOMB');
		-- dbms_output.put_line(sqlerrm);
end;

BEGIN

FOR REC_cl_ACCOUNT IN cur_cl_account LOOP
	l_pwhere := CHR(39) || REC_cl_ACCOUNT.aCCOUNT_NUMBER || CHR(39);
	l_directory := '/tmp/';
	l_filename := REC_cl_ACCOUNT.aCCOUNT_NUMBER || '.INC';
	
dump_tbl('CLTB_ACCOUNT_ADVICE_SUPPRESS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'w');

dump_tbl('CLTB_ACCOUNT_APPS_MASTER ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTBS_CALC_DATES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_CHANGE_LOG ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMPONENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMPONENTS_AMND ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_BALANCES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_BAL_BREAKUP ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_BAL_CRAC ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_BAL_SUMMARY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_CALC  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_SCH  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_SCH_AMND ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_SCH_CRAC ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COMP_SCH_HISTORY   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_DSBR_CHARGES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_DSBR_DETAIL  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_DSBR_DETAIL_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_DSBR_MASTER   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_DSBR_MASTER_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_EVENTS_ADVICES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_EVENTS_DIARY  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_HOL_PERDS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_HOL_PERDS_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_LINKAGES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_LINKAGES_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_LINKAGES_HISTORY   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_MASTER_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_MASTER_AMND_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_PARTIES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_PARTIES_AMND ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_PARTIES_HISTORY  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_PROMOTIONS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_PROMOTIONS_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_ROLL ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_ROLL_COMP ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_ROLL_COMP_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCHEDULES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCHEDULES_AMND ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCHEDULES_BAL  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCHEDULES_CRAC ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCHEDULES_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_SCH_BAL_CRAC ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

--dump_tbl('CLTB_ACCOUNT_STCH_CHARGES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

--dump_tbl('CLTB_ACCOUNT_STSH_CHARGES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_UDE_EFF_DATES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_UDE_VALUES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_UDE_VALUES_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_VAMD ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_VAMD_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_COMPONENTS_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_COMP_SCH_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_DSBR_CHARGES_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_HOL_PERDS_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_HOL_PERDS_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_LINKAGES_AMND_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_PARTIES_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_ROLL_COMP_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_SCHEDULES_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_UDE_EFFDT_AMND_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_UDE_EFF_DATES_AMND  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_UDE_EFF_DATES_HISTORY  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_UDE_VALUES_AMND_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACC_UDE_VALUES_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ADHOC_CHARGES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_AMOUNT_PAID ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_AMOUNT_PAID_HISTORY  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_AMOUNT_RECD ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_AMOUNT_RECD_HISTORY  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_CALC_DATES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_COMP_BALANCES_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_DISBR_SCHEDULES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_DISBR_SCHEDULES_AMND   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');                                                                        

dump_tbl('CLTB_DISBR_SCH_AMND_HIST  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EVENT_CHECK_LIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EVENT_ENTRIES  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EVENT_ENTRIES_PENDING  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EVENT_OVD ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EVENT_REMARKS  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_EXCEPTION_LOG  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_IFACEQRY_ONLINE_CALC ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_INACTIVE_EVENTS_DIARY   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ_COMP_SETTLED ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ_COMP_SUMMARY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ_PENAL_RATES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ_SETTLEMENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_LIQ_SUSPENSION ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_LIQ  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_LIQ_COMP_SETTLED ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_LIQ_COMP_SUMMARY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_LIQ_PENAL_RATES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_LIQ_SETTLEMENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_MANUAL_STCH  ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_MANUAL_STSH ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_PROCESSED_REVISIONS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_REVISION_ACCOUNTS   ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_REVN_SCHEDULES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_REVN_SCHEDULES_AMND ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');                                                                           

dump_tbl('CLTB_REVN_SCH_AMND_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ROLL_COMPONENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ROLL_COMP_SETTLED ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ROLL_SETTLEMENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_SETTLEMENT_EXCEPTION ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COLL_DET ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_COLL_DET_HIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_ADVICE_SUPPRESS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_CHANGE_LOG ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_COMPONENTS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_COMP_SCH ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_EVENTS_ADVICES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_EVENT_USERDEF ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_HOL_PERDS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_LINKAGES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_MASTER ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_PARTIES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_PROMOTIONS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_ROLL_COMP ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_UDE_EFF_DATES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_ACCOUNT_UDE_VALUES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_AMOUNT_PAID ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_AMOUNT_RECD ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_BCH_TAX ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_BCH_TAX_HISTORY ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_DISBR_SCHEDULES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_EVENT_CHECK_LIST ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_EVENT_OVD ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_EVENT_REMARKS ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTC_REVN_SCHEDULES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTP_ACCOUNT_COMP_BALANCES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTP_ACCOUNT_COMP_SCH ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTP_ACCOUNT_IRR ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTB_ACCOUNT_IRR ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTP_ACCOUNT_SCHEDULES ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('CLTP_LIQ ','  ACCOUNT_NUMBER='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('ACTB_DAILY_LOG ','  RELATED_ACCOUNT='||l_pwhere,l_directory,l_filename,'a');

dump_tbl('ACTB_HISTORY ','  RELATED_ACCOUNT='||l_pwhere,l_directory,l_filename,'a'); 

END LOOP;
END;
/
