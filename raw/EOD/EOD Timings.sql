-- Detail timings by batch per branch
SELECT h.branch_code branch,h.eoc_stage stage,h.eoc_batch batch ,
decode(h.eoc_stage,'POSTBOD',h.start_time-1,h.start_time)start_time,
decode(h.eoc_stage,'POSTBOD',h.end_time-1,h.end_time) end_time,
ceil((h.end_time-h.start_time)*24*60) RUNTIME 
FROM Aetb_Eoc_Programs_History h
where h.eod_date ='&DateEod'
--and h.branch_code ='&Branch'
and h.eoc_batch ='&Batch'
order by h.branch_code,h.eoc_stage_seq,h.eoc_batch_seq;  

-- Detail Timings per stage per branch
SELECT ss.branch,ss.stage,min(ss.start_time) start_time,max(ss.end_time) end_time, ceil((max(ss.end_time) - min(ss.start_time))*24*60) runtime
FROM
(
 SELECT h.branch_code branch,h.eoc_stage stage,h.eoc_batch batch ,h.eoc_stage_seq sequence,
 decode(h.eoc_stage,'POSTBOD',h.start_time-1,h.start_time)start_time,
 decode(h.eoc_stage,'POSTBOD',h.end_time-1,h.end_time) end_time,
 ceil((h.end_time-h.start_time)*24*60) RUNTIME 
 FROM Aetb_Eoc_Programs_History h
 where h.eod_date ='&DateEod'
-- and h.branch_code ='&Branch'
 order by h.branch_code,h.eoc_stage_seq,h.eoc_batch_seq
) ss
group by ss.branch,ss.sequence,ss.stage
order by ss.branch,ss.sequence,ss.stage;

-- Global timing for EOD
SELECT  min(ss.start_time) start_time,max(ss.end_time) end_time, 
floor ( (max(ss.end_time) - min(ss.start_time))*24)||' Hrs '|| (ceil((max(ss.end_time) - min(ss.start_time))*24*60) -floor ( (max(ss.end_time) - min(ss.start_time))*24)*60)||' Mns' 
runtime
FROM
(
 SELECT h.branch_code branch,h.eoc_stage stage,h.eoc_batch batch ,h.eoc_stage_seq sequence,
 decode(h.eoc_stage,'POSTBOD',h.start_time-1,h.start_time)start_time,
 decode(h.eoc_stage,'POSTBOD',h.end_time-1,h.end_time) end_time,
 ceil((h.end_time-h.start_time)*24*60) RUNTIME 
 FROM Aetb_Eoc_Programs_History h
 where h.eod_date ='&DateEod'
 order by h.branch_code,h.eoc_stage_seq,h.eoc_batch_seq
) ss;

 
