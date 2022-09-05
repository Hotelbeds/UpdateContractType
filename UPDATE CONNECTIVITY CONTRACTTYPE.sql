SELECT FD."ContractType",  
CASE WHEN CD."PRICETYPE" = 'X' THEN 'BAR' WHEN CD."PRICETYPE"  = 'N' THEN 'FIT' ELSE '' END
FROM  "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."CPT_FTPDAILY" FD
 INNER JOIN "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."SGDB_tbl_PC_Integration_TPS" I ON  FD."Hotel Code" = I."Atlas Code"   AND I."Integration Code" =   split_part("Connectivity Name",'-',1)   
  INNER JOIN "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."SGDB_ConnectivityDetails" CD ON CD."CRSCODE" = I."CRS" AND CD."BRANDCODE" = I."Brand Code" AND CD."RATE" = split_part(FD."Contract Name",'#',2)
 WHERE "Process Date" = '2021-06-15'
AND "Contract Name" LIKE '%ID_B2B%'
GROUP BY "ContractType", CD."PRICETYPE"



 
 update "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."CPT_FTPDAILY" FD set  FD."ContractType" =
CASE WHEN CD."PRICETYPE" = 'X' THEN 'BAR' WHEN CD."PRICETYPE" = 'N' THEN 'FIT' ELSE '' END
from "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."SGDB_tbl_PC_Integration_TPS" I
INNER JOIN "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."SGDB_ConnectivityDetails" CD ON CD."CRSCODE" = I."CRS" AND CD."BRANDCODE" = I."Brand Code"  
WHERE "Process Date" = '2021-06-15'
AND FD."Contract Name" LIKE '%ID_B2B%'  and FD."Hotel Code" = I."Atlas Code" AND I."Integration Code" = split_part("Connectivity Name",'-',1)
 AND CD."RATE" = split_part(FD."Contract Name",'#',2) and FD."ContractType" is null


---------------------------------------------------------------------------------------------------------------------------------------LATEST
 update "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."CPT_FTPDAILY" A set  A."ContractType" =B."ContractType" 
 
 
FROM "HBG_COMPETITIVE_INTELLIGENCE"."SANDBOX_SOURCE"."SGDB_HotelContract" B
WHERE  A."Hotel Code" = B."HotelID"
AND  A."Contract Name"  = B."ContractName"
 
AND   A."Process Date" = '2021-06-15'
AND (
  DATE(A."CheckinDate")  BETWEEN DATE(B."DateFrom")  AND  DATE(B."DateTo") 
  OR
  DATEADD(DAY, "LOS", DATE(A."CheckinDate"))
  BETWEEN DATE(B."DateFrom")   AND DATE(B."DateTo") 
  OR
  DATE(B."DateFrom")  
  BETWEEN DATE(A."CheckinDate" ) AND   DATEADD(DAY, "LOS", DATE(A."CheckinDate"))
  OR
  DATE(B."DateTo")   
  BETWEEN DATE(A."CheckinDate" ) AND   DATEADD(DAY, "LOS", DATE(A."CheckinDate"))
  )    
  AND  A."ContractType" IS NULL
 