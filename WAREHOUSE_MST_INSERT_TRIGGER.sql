DELIMITER $ 

CREATE OR REPLACE TRIGGER WAREHOUSE_MST_INSERT AFTER
    INSERT ON `WAREHOUSE_MST`
    FOR EACH ROW
BEGIN  
DECLARE I_ITEM_ID INT(11);
DECLARE I_VRT_ID INT(11); 

DECLARE ITEM_MST_CUR CURSOR FOR
     SELECT `ITEM_ID` FROM `ITEM_MST`;       

DECLARE VARIATION_MST_CUR CURSOR FOR
     SELECT `VRT_ID` FROM `VARIATION_MST`;       


OPEN ITEM_MST_CUR;   
    BEGIN 
    DECLARE ITEM_DONE INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET ITEM_DONE = 1; 
      ITEMLOOP: LOOP  
        FETCH ITEM_MST_CUR INTO I_ITEM_ID;  
        IF  ITEM_DONE = 1 THEN 
           LEAVE ITEMLOOP;  
        END IF;          
        OPEN VARIATION_MST_CUR;  
            BEGIN  
            DECLARE VARIATION_DONE INTEGER DEFAULT 0;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET VARIATION_DONE = 1;
            VARIATIONLOOP: LOOP
                FETCH VARIATION_MST_CUR INTO I_VRT_ID;
                IF VARIATION_DONE = 1 THEN 
                    LEAVE VARIATIONLOOP;
                END IF;
                INSERT INTO `ITEM_STOCK_MST` (`ITEM_ID`,`VRT_ID`,`WRHS_ID`,`STOCK`,`ISM_CRTD_DATE`) VALUES (I_ITEM_ID,I_VRT_ID,NEW.WRHS_ID,0,SYSDATE());
            END LOOP VARIATIONLOOP; 
            END ;  
        CLOSE VARIATION_MST_CUR;                    
       END LOOP ITEMLOOP;   
       END; 
    CLOSE ITEM_MST_CUR;     
END $

DELIMITER ; 
 

