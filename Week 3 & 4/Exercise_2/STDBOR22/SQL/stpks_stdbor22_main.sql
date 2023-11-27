CREATE OR REPLACE PACKAGE BODY stpks_stdbor22_main AS
     /*-----------------------------------------------------------------------------------------------------
     **
     ** File Name  : stpks_stdbor22_main.sql
     **
     ** Module     : Static Maintenance
     ** 
     ** This source is part of the Oracle FLEXCUBE Software Product.
     ** Copyright (R) 2008,2023 , Oracle and/or its affiliates.  All rights reserved
     ** 
     ** 
     ** No part of this work may be reproduced, stored in a retrieval system, adopted 
     ** or transmitted in any form or by any means, electronic, mechanical, 
     ** photographic, graphic, optic recording or otherwise, translated in any 
     ** language or computer language, without the prior written permission of 
     ** Oracle and/or its affiliates. 
     ** 
     ** Oracle Financial Services Software Limited.
     ** Oracle Park, Off Western Express Highway,
     ** Goregaon (East), 
     ** Mumbai - 400 063, India
     ** India
     -------------------------------------------------------------------------------------------------------
     CHANGE HISTORY
     
     SFR Number         :  
     Changed By         :  
     Change Description :  
     
     -------------------------------------------------------------------------------------------------------
     */
     

   g_Ui_Name            VARCHAR2(50) := 'STDBOR22';
   g_stdbor22         stpks_stdbor22_Main.ty_stdbor22;
   g_Req_Key                 VARCHAR2(32767);
   g_Key_Id                  VARCHAR2(32767);
   g_Post_Upl_Stat     VARCHAR2(1);
   g_Curr_Stage        VARCHAR2(20);
   g_Tanking_Status      VARCHAR2(1);
   --Skip Handler Variables
   g_Skip_Sys       BOOLEAN := FALSE;
   g_Skip_Custom    BOOLEAN := FALSE;
   PROCEDURE Dbg(p_msg VARCHAR2)  IS
      l_Msg     VARCHAR2(32767);
   BEGIN
      IF debug.pkg_debug_on <> 2 THEN
         l_Msg := 'stpks_stdbor22_Main ==>'||p_Msg;
         Debug.Pr_Debug('ST' ,l_Msg);
      END IF;
   END Dbg;

   PROCEDURE Pr_Log_Error(p_Source VARCHAR2,p_Err_Code VARCHAR2, p_Err_Params VARCHAR2) IS
      l_Fid    VARCHAR2(32767) := 'STDBOR22';
   BEGIN
      Cspks_Req_Utils.Pr_Log_Error(p_Source,l_Fid,p_Err_Code,p_Err_Params);
   END Pr_Log_Error;
   FUNCTION  Fn_Get_Curr_Stage RETURN VARCHAR2 IS
   BEGIN
      RETURN g_Curr_Stage;
   END  Fn_Get_Curr_Stage;
   FUNCTION  Fn_Get_Tanked_Stat RETURN VARCHAR2 IS
   BEGIN
      RETURN g_Tanking_Status;
   END  Fn_get_tanked_stat;
   PROCEDURE Pr_Skip_Handler(p_Stage in VARCHAR2) IS
   BEGIN
      stpks_stdbor22_Custom.Pr_Skip_Handler (P_Stage);
   END Pr_Skip_Handler;
   PROCEDURE Pr_Set_Skip_Sys IS
   BEGIN
      g_Skip_Sys := TRUE;
   END Pr_Set_Skip_Sys;
   PROCEDURE Pr_Set_Activate_Sys IS
   BEGIN
      g_Skip_Sys := FALSE;
   END Pr_Set_Activate_Sys;
   FUNCTION  Fn_Skip_Sys RETURN BOOLEAN IS
   BEGIN
      RETURN G_Skip_Sys;
   END  Fn_Skip_Sys;
   PROCEDURE Pr_Set_Skip_Custom IS
   BEGIN
      g_Skip_Custom := TRUE;
   END Pr_Set_Skip_Custom;
   PROCEDURE Pr_Set_Activate_Custom IS
   BEGIN
      g_Skip_Custom := FALSE;
   END Pr_Set_Activate_Custom;
   FUNCTION  Fn_Skip_Custom RETURN BOOLEAN IS
   BEGIN
      IF g_curr_stage IS NOT NULL THEN
         RETURN G_Skip_Custom;
      ELSIF Cspks_Req_Global.g_Release_Type IN(Cspks_Req_Global.p_Kernel,Cspks_Req_Global.P_Cluster) THEN
         RETURN TRUE;
      ELSIF Cspks_Req_Global.g_Release_Type =Cspks_Req_Global.p_Custom THEN
         RETURN FALSE;
      ELSE
         RETURN G_Skip_Custom;
      END IF;
   END  Fn_Skip_Custom;
   FUNCTION Fn_Sys_Build_Fc_Type (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Addl_Info       IN Cspks_Req_Global.Ty_Addl_Info,
      p_stdbor22       IN   OUT stpks_stdbor22_Main.ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Pk_counter        NUMBER :=1;
      l_Count             NUMBER;
      l_Parent_Rec        NUMBER :=0;
      l_Key               VARCHAR2(255);
      l_Pkey              VARCHAR2(32767);
      l_PVal              VARCHAR2(32767);
      l_Val               VARCHAR2(32767);
      l_Tag               VARCHAR2(100);
      l_Node              VARCHAR2(100);
      l_Key_Vals          VARCHAR2(32767);
      l_Key_Tags          VARCHAR2(32767);
      l_Source_Operation  VARCHAR2(100) := p_Source_Operation;
      l_Dsn_Rec_Cnt_2    NUMBER;
      l_Bnd_Cntr_2    NUMBER;

   BEGIN

      dbg('In Fn_Sys_Build_Fc_Type..');

      l_Node := Cspks_Req_Global.Fn_GetNode;
      WHILE (l_Node <> 'EOPL')
      LOOP
         --Dbg('Node Name  :'||l_Node);
         IF  l_Node = 'BLK_MAIN' THEN
            p_stdbor22.v_sttm_bor22_master.CAT := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.DESCRIPT := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.RELATIONSHIP := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.MAKER_ID := Cspks_Req_Global.Fn_GetVal;
            l_Val       := Cspks_Req_Global.Fn_GetVal;
            IF Length(l_Val) > Length(Cspks_Req_Global.g_Date_Format) THEN
               p_stdbor22.v_sttm_bor22_master.MAKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Time_Format);
            ELSE
               p_stdbor22.v_sttm_bor22_master.MAKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Format);
            END IF;
            p_stdbor22.v_sttm_bor22_master.CHECKER_ID := Cspks_Req_Global.Fn_GetVal;
            l_Val       := Cspks_Req_Global.Fn_GetVal;
            IF Length(l_Val) > Length(Cspks_Req_Global.g_Date_Format) THEN
               p_stdbor22.v_sttm_bor22_master.CHECKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Time_Format);
            ELSE
               p_stdbor22.v_sttm_bor22_master.CHECKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Format);
            END IF;
            p_stdbor22.v_sttm_bor22_master.MOD_NO := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.RECORD_STAT := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.AUTH_STAT := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_master.ONCE_AUTH := Cspks_Req_Global.Fn_GetVal;
         ELSIF  l_Node = 'BLK_BOTTOM' THEN
            l_Dsn_Rec_Cnt_2 :=  p_stdbor22.v_sttm_bor22_detail.count +1 ;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).CAT := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).PRODUCT_CODE := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).RELATIONSHIP := Cspks_Req_Global.Fn_GetVal;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).cat :=p_stdbor22.v_sttm_bor22_master.cat;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).relationship :=p_stdbor22.v_sttm_bor22_master.relationship;
         END IF;
         l_Node := Cspks_Req_Global.Fn_GetNode;
      END LOOP;

      p_stdbor22.Addl_Info := p_Addl_Info;
      Dbg('Returning Success From Fn_Sys_Build_Fc_Type.. ');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Sys_Build_Fc_Type ');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Build_Fc_Type;
   FUNCTION Fn_Sys_Build_Ws_Type (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Addl_Info       IN Cspks_Req_Global.Ty_Addl_Info,
      p_stdbor22       IN   OUT stpks_stdbor22_Main.ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Pk_counter        NUMBER :=1;
      l_Count             NUMBER;
      l_Parent_Rec        NUMBER :=0;
      l_Key               VARCHAR2(255);
      l_Pkey              VARCHAR2(32767);
      l_PVal              VARCHAR2(32767);
      l_Val               VARCHAR2(32767);
      l_Tag               VARCHAR2(100);
      l_Node              VARCHAR2(100);
      l_Key_Vals          VARCHAR2(32767);
      l_Key_Tags          VARCHAR2(32767);
      l_Source_Operation  VARCHAR2(100) := p_Source_Operation;
      Invalid_Date        EXCEPTION;
      l_Dsn_Rec_Cnt_2    NUMBER;
      l_Bnd_Cntr_2    NUMBER;

   BEGIN

      dbg('In Fn_Sys_Build_Ws_Type..');

      l_Node := Cspks_Req_Global.Fn_GetNode;
      WHILE (l_Node <> 'EOPL')
      LOOP
         --Dbg('Node Name  :'||l_Node);
         IF  l_Node IN ( 'BLK_MAIN','Main-Full','Main-IO') THEN
            l_Key       := Cspks_Req_Global.Fn_GetTag;
            l_Val       := Cspks_Req_Global.Fn_GetVal;
            WHILE (l_Key <> 'EOPL')
            LOOP
               --dbg('Key/Value   :'||l_Key ||':'||l_Val);
               IF l_Key = 'CAT' THEN
                  p_stdbor22.v_sttm_bor22_master.CAT := l_Val;
               ELSIF l_Key = 'DESCRIPT' THEN
                  p_stdbor22.v_sttm_bor22_master.DESCRIPT := l_Val;
               ELSIF l_Key = 'PRODUCT_RESTRICTION' THEN
                  p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION := l_Val;
               ELSIF l_Key = 'RELATIONSHIP' THEN
                  p_stdbor22.v_sttm_bor22_master.RELATIONSHIP := l_Val;
               ELSIF l_Key = 'MAKER' THEN
                  p_stdbor22.v_sttm_bor22_master.MAKER_ID := l_Val;
               ELSIF l_Key = 'MAKERSTAMP' THEN
                  BEGIN
                     IF Length(l_Val) > Length(Cspks_Req_Global.g_Date_Format) THEN
                        p_stdbor22.v_sttm_bor22_master.MAKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Time_Format);
                     ELSE
                        p_stdbor22.v_sttm_bor22_master.MAKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Format);
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
                        RAISE Invalid_Date;
                  END;
               ELSIF l_Key = 'CHECKER' THEN
                  p_stdbor22.v_sttm_bor22_master.CHECKER_ID := l_Val;
               ELSIF l_Key = 'CHECKERSTAMP' THEN
                  BEGIN
                     IF Length(l_Val) > Length(Cspks_Req_Global.g_Date_Format) THEN
                        p_stdbor22.v_sttm_bor22_master.CHECKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Time_Format);
                     ELSE
                        p_stdbor22.v_sttm_bor22_master.CHECKER_DT_STAMP := TO_DATE(l_val,Cspks_Req_Global.g_Date_Format);
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
                        RAISE Invalid_Date;
                  END;
               ELSIF l_Key = 'MODNO' THEN
                  p_stdbor22.v_sttm_bor22_master.MOD_NO := l_Val;
               ELSIF l_Key = 'TXNSTAT' THEN
                  p_stdbor22.v_sttm_bor22_master.RECORD_STAT := l_Val;
               ELSIF l_Key = 'AUTHSTAT' THEN
                  p_stdbor22.v_sttm_bor22_master.AUTH_STAT := l_Val;
               ELSIF l_Key = 'ONCEAUTH' THEN
                  p_stdbor22.v_sttm_bor22_master.ONCE_AUTH := l_Val;
               END IF;
               l_Key       := Cspks_Req_Global.Fn_GetTag;
               l_Val       := Cspks_Req_Global.Fn_GetVal;
            END LOOP;
         ELSIF  l_Node IN ( 'BLK_BOTTOM','Bottom') THEN
            l_Dsn_Rec_Cnt_2 :=  p_stdbor22.v_sttm_bor22_detail.count +1 ;
            l_Key       := Cspks_Req_Global.Fn_GetTag;
            l_Val       := Cspks_Req_Global.Fn_GetVal;
            WHILE (l_Key <> 'EOPL')
            LOOP
               --dbg('Key/Value   :'||l_Key ||':'||l_Val);
               IF l_Key = 'CAT' THEN
                  p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).CAT := l_Val;
               ELSIF l_Key = 'PRODUCT_CODE' THEN
                  p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).PRODUCT_CODE := l_Val;
               ELSIF l_Key = 'RELATIONSHIP' THEN
                  p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).RELATIONSHIP := l_Val;
               END IF;
               l_Key       := Cspks_Req_Global.Fn_GetTag;
               l_Val       := Cspks_Req_Global.Fn_GetVal;
            END LOOP;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).cat :=p_stdbor22.v_sttm_bor22_master.cat;
            p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).relationship :=p_stdbor22.v_sttm_bor22_master.relationship;
         END IF;
         l_Node := Cspks_Req_Global.Fn_GetNode;
      END LOOP;

      p_stdbor22.Addl_Info := p_Addl_Info;
      Dbg('Returning Success From Fn_Sys_Build_Fc_Type.. ');
      RETURN TRUE;

   EXCEPTION
      WHEN Invalid_Date THEN
         Pr_Log_Error(p_Source,'ST-OTHR-003',l_Key||'~'||Cspks_Req_Global.g_Date_Format) ;
         RETURN FALSE;
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Sys_Build_Fc_Type ');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Build_Ws_Type;
   FUNCTION Fn_Sys_Build_Fc_Ts (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_stdbor22          IN stpks_stdbor22_Main.ty_stdbor22,
      p_Err_Code        IN OUT VARCHAR2,
      p_Err_Params      IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Level_Format  VARCHAR2(32767);
      l_Parent_Format VARCHAR2(32767);
      l_Date_Val      VARCHAR2(32767);
      l_Master_Childs NUMBER := 0;
      l_Desc_Vc          VARCHAR2(32767);
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_0_Lvl_Counter NUMBER := 0;
      l_1_Lvl_Counter NUMBER := 0;
      l_2_Lvl_Counter   NUMBER := 0;
      l_Dsn_Rec_Cnt_2    NUMBER;
      l_Bnd_Cntr_2    NUMBER;
      l_Cntr_Before   NUMBER := 0;
      l_Master_Where  VARCHAR2(32767);
      l_Count         NUMBER := 0;

   BEGIN
      Dbg('In Fn_Sys_Build_Fc_Ts..');

      --Dbg('Building Childs Of :..');
      l_1_Lvl_Counter := 0;
      l_0_Lvl_Counter   := l_0_Lvl_Counter +1;
      l_Level_Format      := l_0_Lvl_Counter;
      Cspks_Req_Global.Pr_Write('P','BLK_MAIN',l_Level_Format);
      Cspks_Req_Global.Pr_Write('V','CAT',p_stdbor22.v_sttm_bor22_master.cat);
      Cspks_Req_Global.Pr_Write('V','DESCRIPT',p_stdbor22.v_sttm_bor22_master.descript);
      Cspks_Req_Global.Pr_Write('V','PRODUCT_RESTRICTION',p_stdbor22.v_sttm_bor22_master.product_restriction);
      Cspks_Req_Global.Pr_Write('V','RELATIONSHIP',p_stdbor22.v_sttm_bor22_master.relationship);
      Cspks_Req_Global.Pr_Write('V','MAKER',p_stdbor22.v_sttm_bor22_master.maker_id);
      IF trunc(p_stdbor22.v_sttm_bor22_master.maker_dt_stamp) <>
            p_stdbor22.v_sttm_bor22_master.maker_dt_stamp THEN
         l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.maker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Time_Format);
      ELSE
         l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.maker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Format);
      END IF;
      Cspks_Req_Global.Pr_Write('V','MAKERSTAMP',l_Date_Val);
      Cspks_Req_Global.Pr_Write('V','CHECKER',p_stdbor22.v_sttm_bor22_master.checker_id);
      IF trunc(p_stdbor22.v_sttm_bor22_master.checker_dt_stamp) <>
            p_stdbor22.v_sttm_bor22_master.checker_dt_stamp THEN
         l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.checker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Time_Format);
      ELSE
         l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.checker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Format);
      END IF;
      Cspks_Req_Global.Pr_Write('V','CHECKERSTAMP',l_Date_Val);
      Cspks_Req_Global.Pr_Write('V','MODNO',p_stdbor22.v_sttm_bor22_master.mod_no);
      Cspks_Req_Global.Pr_Write('V','TXNSTAT',p_stdbor22.v_sttm_bor22_master.record_stat);
      Cspks_Req_Global.Pr_Write('V','AUTHSTAT',p_stdbor22.v_sttm_bor22_master.auth_stat);
      Cspks_Req_Global.Pr_Write('V','ONCEAUTH',p_stdbor22.v_sttm_bor22_master.once_auth);

      --Dbg('Building Childs Of :BLK_MAIN..');
      l_Dsn_Rec_Cnt_2 := 0;
      IF p_stdbor22.v_sttm_bor22_detail.COUNT > 0 THEN
         FOR i_2 IN  1..p_stdbor22.v_sttm_bor22_detail.COUNT LOOP
            l_Dsn_Rec_Cnt_2 := i_2;
            l_Master_Childs  :=  l_Master_Childs +1;
            l_1_Lvl_Counter   := l_1_Lvl_Counter +1;
            l_Level_Format      := l_0_Lvl_Counter||'.'||l_1_Lvl_Counter;
            Cspks_Req_Global.Pr_Write('P','BLK_BOTTOM',l_Level_Format);
            Cspks_Req_Global.Pr_Write('V','CAT',p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).cat);
            Cspks_Req_Global.Pr_Write('V','PRODUCT_CODE',p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).product_code);
            Cspks_Req_Global.Pr_Write('V','RELATIONSHIP',p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).relationship);
         END LOOP;
      END IF;
      Dbg('Returning Success From Fn_Sys_Build_Fc_Ts..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Build_Fc_Ts..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Build_Fc_Ts;
   FUNCTION Fn_Sys_Build_Ws_Ts (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Exchange_Pattern IN       VARCHAR2,
      p_stdbor22          IN stpks_stdbor22_Main.ty_stdbor22,
      p_Err_Code        IN OUT VARCHAR2,
      p_Err_Params      IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Level_Format  VARCHAR2(32767);
      l_Parent_Format VARCHAR2(32767);
      l_Date_Val      VARCHAR2(32767);
      l_Master_Childs NUMBER := 0;
      l_Desc_Vc          VARCHAR2(32767);
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_Key_Cols          VARCHAR2(32767);
      l_Key_Vals          VARCHAR2(32767);
      l_0_Lvl_Counter NUMBER := 0;
      l_1_Lvl_Counter NUMBER := 0;
      l_2_Lvl_Counter   NUMBER := 0;
      l_Dsn_Rec_Cnt_2    NUMBER;
      l_Bnd_Cntr_2    NUMBER;
      l_Cntr_Before   NUMBER := 0;
      l_Master_Where  VARCHAR2(32767);
      l_Count         NUMBER := 0;

   BEGIN
      Dbg('In Fn_Sys_Build_Ws_Ts..');
      IF SUBSTR(p_Exchange_Pattern,3,4) = 'FS' THEN
         Dbg('Building Full Screen Reply..');

         --Dbg('Building Childs Of :..');
         IF (  p_stdbor22.v_sttm_bor22_master.relationship IS NOT NULL 
         AND  p_stdbor22.v_sttm_bor22_master.cat IS NOT NULL 
          )
          THEN
            l_1_Lvl_Counter := 0;
            l_0_Lvl_Counter   := l_0_Lvl_Counter +1;
            l_Level_Format      := l_0_Lvl_Counter;
            Cspks_Req_Global.Pr_Write('P','Main-Full',l_Level_Format);
            Cspks_Req_Global.Pr_Write('V','CAT',p_stdbor22.v_sttm_bor22_master.cat);
            Cspks_Req_Global.Pr_Write('V','DESCRIPT',p_stdbor22.v_sttm_bor22_master.descript);
            Cspks_Req_Global.Pr_Write('V','PRODUCT_RESTRICTION',p_stdbor22.v_sttm_bor22_master.product_restriction);
            Cspks_Req_Global.Pr_Write('V','RELATIONSHIP',p_stdbor22.v_sttm_bor22_master.relationship);
            Cspks_Req_Global.Pr_Write('V','MAKER',p_stdbor22.v_sttm_bor22_master.maker_id);
            IF trunc(p_stdbor22.v_sttm_bor22_master.maker_dt_stamp) <>
                  p_stdbor22.v_sttm_bor22_master.maker_dt_stamp THEN
               l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.maker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Time_Format);
            ELSE
               l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.maker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Format);
            END IF;
            Cspks_Req_Global.Pr_Write('V','MAKERSTAMP',l_Date_Val);
            Cspks_Req_Global.Pr_Write('V','CHECKER',p_stdbor22.v_sttm_bor22_master.checker_id);
            IF trunc(p_stdbor22.v_sttm_bor22_master.checker_dt_stamp) <>
                  p_stdbor22.v_sttm_bor22_master.checker_dt_stamp THEN
               l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.checker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Time_Format);
            ELSE
               l_Date_Val :=  TO_CHAR( p_stdbor22.v_sttm_bor22_master.checker_dt_stamp,Cspks_Req_Global.g_Ws_Date_Format);
            END IF;
            Cspks_Req_Global.Pr_Write('V','CHECKERSTAMP',l_Date_Val);
            Cspks_Req_Global.Pr_Write('V','MODNO',p_stdbor22.v_sttm_bor22_master.mod_no);
            Cspks_Req_Global.Pr_Write('V','TXNSTAT',p_stdbor22.v_sttm_bor22_master.record_stat);
            Cspks_Req_Global.Pr_Write('V','AUTHSTAT',p_stdbor22.v_sttm_bor22_master.auth_stat);

            --Dbg('Building Childs Of :BLK_MAIN..');
            l_Dsn_Rec_Cnt_2 := 0;
            IF p_stdbor22.v_sttm_bor22_detail.COUNT > 0 THEN
               FOR i_2 IN  1..p_stdbor22.v_sttm_bor22_detail.COUNT LOOP
                  l_Dsn_Rec_Cnt_2 := i_2;
                  l_Master_Childs  :=  l_Master_Childs +1;
                  l_1_Lvl_Counter   := l_1_Lvl_Counter +1;
                  l_Level_Format      := l_0_Lvl_Counter||'.'||l_1_Lvl_Counter;
                  Cspks_Req_Global.Pr_Write('P','Bottom',l_Level_Format);
                  Cspks_Req_Global.Pr_Write('V','PRODUCT_CODE',p_stdbor22.v_sttm_bor22_detail(l_Dsn_Rec_Cnt_2).product_code);
               END LOOP;
            END IF;
         END IF;
      ELSE
         Dbg('Building Primary Key Reply..');
         Cspks_Req_Global.pr_Write('P','Main-PK','1');
         l_Key_Cols := 'RELATIONSHIP~'||'CAT~';
         l_Key_Vals := p_stdbor22.v_sttm_bor22_master.relationship||'~'||p_stdbor22.v_sttm_bor22_master.cat||'~';
         Cspks_Req_Global.pr_Write('V',l_Key_Cols,l_Key_Vals);
      END IF;
      Dbg('Returning Success From Fn_Sys_Build_Ws_Ts..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Build_Fc_Ts..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Build_Ws_Ts;
   FUNCTION Fn_Sys_Check_Mandatory (p_Source    IN  VARCHAR2,
      p_Pk_Or_Full     IN  VARCHAR2 DEFAULT 'FULL',
      p_stdbor22 IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code       IN  OUT VARCHAR2,
      p_Err_Params     IN  OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_Count          NUMBER:= 0;
      l_Key            VARCHAR2(5000);
      l_Blk            VARCHAR2(100);
      l_Fld            VARCHAR2(100);
      l_Rec_Sent       BOOLEAN := TRUE;
      l_Base_Data_From_Fc  VARCHAR2(1):= 'Y';

   BEGIN

      Dbg('In Fn_Sys_Check_Mandatory..');

      l_Fld := 'STTM_BOR22_MASTER.RELATIONSHIP';
      IF p_stdbor22.v_sttm_bor22_master.relationship IS Null THEN
         Dbg('Field relationship is Null..');
         p_Err_Code    := 'ST-MAND-001';
         p_Err_Params := '@'||l_Fld;
         RETURN FALSE;
      END IF;
      l_Fld := 'STTM_BOR22_MASTER.CAT';
      IF p_stdbor22.v_sttm_bor22_master.cat IS Null THEN
         Dbg('Field cat is Null..');
         p_Err_Code    := 'ST-MAND-001';
         p_Err_Params := '@'||l_Fld;
         RETURN FALSE;
      END IF;

      IF p_Pk_Or_Full = 'FULL'  THEN
         Dbg('Full Mandatory Checks..');

         l_Blk := 'STTM_BOR22_MASTER';

         l_Blk := 'STTM_BOR22_DETAIL';
         l_Count := p_stdbor22.v_sttm_bor22_detail.COUNT;
         IF l_Count > 0 THEN
            FOR l_index IN 1 .. p_stdbor22.v_sttm_bor22_detail.COUNT LOOP
               l_Fld := 'STTM_BOR22_DETAIL.PRODUCT_CODE';
               IF p_stdbor22.v_sttm_bor22_detail(l_Index).product_code IS Null THEN
                  Dbg('Primary Key Column product_code Cannot Be Null');
                  l_Key := Null;
                  Pr_Log_Error(p_Source,'ST-MAND-003','@'||l_Fld||'~@'||l_Blk||'~'||l_index );
               END IF;
            END LOOP;
         END IF;
      END IF;

      Dbg('Returning Success From Fn_Sys_Check_Mandatory ..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_debug('**','In When Others of Fn_Sys_Check_Mandatory ..');
         Debug.Pr_debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Sys_Check_Mandatory;
   FUNCTION Fn_Sys_Basic_Vals        (p_Source            IN VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.ty_stdbor22,
      p_Err_code          IN OUT VARCHAR2,
      p_Err_params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Count          NUMBER:= 0;
      l_Key            VARCHAR2(5000):= NULL;
      i                NUMBER := 1;
      l_Blk            VARCHAR2(100):= 0;
      l_Fld            VARCHAR2(100):= 0;
      l_Inv_Chr        VARCHAR2(5) :=NULL;
   BEGIN

      Dbg('In Fn_Sys_Basic_Vals..');
      IF p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION IS NOT NULL THEN
         IF p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION NOT IN ('Allowed','Disallowed') THEN
            dbg('Invalid Value For The Field  :PRODUCT_RESTRICTION:'||p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION);
            Pr_Log_Error(p_Source,'ST-VALS-011',p_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION||'~@STTM_BOR22_MASTER.PRODUCT_RESTRICTION~@STTM_BOR22_MASTER') ;
         END IF;
      END IF;
      Dbg('Duplicate Records Check For :v_sttm_bor22_detail..');
      l_Count      := p_stdbor22.v_sttm_bor22_detail.COUNT;
      IF l_Count > 0 THEN
         FOR l_index  IN 1 .. l_count LOOP
            l_key := NULL;
            IF l_index < l_Count THEN
               FOR l_index1 IN l_index+1 .. l_Count LOOP
                  IF (NVL(p_stdbor22.v_sttm_bor22_detail(l_index).product_code,'@')=  NVL(p_stdbor22.v_sttm_bor22_detail(l_index1).product_code,'@')) AND (NVL(p_stdbor22.v_sttm_bor22_detail(l_index).relationship,'@')=  NVL(p_stdbor22.v_sttm_bor22_detail(l_index1).relationship,'@')) AND (NVL(p_stdbor22.v_sttm_bor22_detail(l_index).cat,'@')=  NVL(p_stdbor22.v_sttm_bor22_detail(l_index1).cat,'@')) THEN
                     Dbg('Duplicare Record Found for :'||l_Key);
                     l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                     p_stdbor22.v_sttm_bor22_detail(l_index).product_code||':'||
                     Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.RELATIONSHIP')||'-'||
                     p_stdbor22.v_sttm_bor22_detail(l_index).relationship||':'||
                     Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.CAT')||'-'||
                     p_stdbor22.v_sttm_bor22_detail(l_index).cat;
                     Pr_Log_Error(p_Source,'ST-VALS-009','@STTM_BOR22_DETAIL~'||l_Key);
                  END IF;
               END LOOP;
            END IF;
         END LOOP;
      END IF;
      Dbg('Returning Success From Fn_Sys_Basic_Vals..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Basic_Vals..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Basic_Vals;

   FUNCTION Fn_Sys_Default_Vals        (p_Source            IN VARCHAR2,
      p_Wrk_stdbor22     IN  OUT stpks_stdbor22_Main.ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Count          NUMBER:= 0;
   BEGIN

      Dbg('In Fn_Sys_Default_Vals..');
      Dbg('Returning Success From Fn_Sys_Default_Vals..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Default_Vals..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Default_Vals;

   FUNCTION Fn_Sys_Merge_Amendables        (p_Source            IN VARCHAR2,
      p_Source_Operation  IN     VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Prev_stdbor22 IN stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22 IN OUT stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Count          NUMBER:= 0;
      l_Wrk_Count      NUMBER := 0 ;
      l_Deleted_Recs   NUMBER := 0;
      l_Modified_Flds  VARCHAR2(32000):= NULL;
      l_Key            VARCHAR2(5000):= NULL;
      l_Mod_Fld        VARCHAR2(100):= NULL;
      i                NUMBER := 1;
      l_Rec_Found      BOOLEAN := FALSE;
      l_Rec_Modified   BOOLEAN := FALSE;
      l_Rec_Sent       BOOLEAN := FALSE;
      l_Blk            VARCHAR2(100):= 0;
      l_Fld            VARCHAR2(100):= 0;
      l_Pk_Or_Full     VARCHAR2(5) :='FULL';
      l_Inv_Chr        VARCHAR2(5) :=NULL;
      l_Mod_No         NUMBER:= 0;
      l_Base_Data_From_Fc  VARCHAR2(1):= 'Y';
      l_Amendable_Nodes Cspks_Req_Global.Ty_Amend_Nodes;
      l_Amendable_Fields Cspks_Req_Global.Ty_Amend_Fields;
      N_v_sttm_bor22_detail       stpks_stdbor22_Main.Ty_Tb_v_sttm_bor22_detail;

      FUNCTION Fn_Amendable(p_Item IN VARCHAR2) RETURN BOOLEAN IS
      BEGIN
         IF l_Amendable_Fields.EXISTS(p_Item) THEN
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END IF;
      END Fn_Amendable;
   BEGIN

      Dbg('In Fn_Sys_Merge_Amendables');

      Dbg('Calling Cspks_Req_Utils.Fn_Get_Amendable_Details..');
      IF NOT Cspks_Req_Utils.Fn_Get_Amendable_Details(p_source ,
         p_Source_Operation,
         l_Amendable_Nodes,
         l_Amendable_Fields,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in Cspks_Req_Utils.Fn_Get_Amendable_Details..');
         Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
      END IF;

      l_Blk := 'STTM_BOR22_MASTER';
      l_Rec_Modified := FALSE;
      l_Modified_Flds  := NULL;

      l_fld := 'STTM_BOR22_MASTER.DESCRIPT';
      IF Fn_Amendable('STTM_BOR22_MASTER.DESCRIPT') THEN
         p_Wrk_stdbor22.v_sttm_bor22_master.descript := p_stdbor22.v_sttm_bor22_master.descript;
      ELSE
         IF p_stdbor22.v_sttm_bor22_master.descript IS NOT NULL THEN
            IF NVL(p_Wrk_stdbor22.v_sttm_bor22_master.descript,'@') <>
               NVL(p_stdbor22.v_sttm_bor22_master.descript,'@')  THEN
               l_Modified_Flds := l_Modified_Flds ||'~'||l_Fld;
               l_Rec_Modified := TRUE;
            END IF;
         END IF;
      END IF;
      l_fld := 'STTM_BOR22_MASTER.PRODUCT_RESTRICTION';
      IF Fn_Amendable('STTM_BOR22_MASTER.PRODUCT_RESTRICTION') THEN
         p_Wrk_stdbor22.v_sttm_bor22_master.product_restriction := p_stdbor22.v_sttm_bor22_master.product_restriction;
      ELSE
         IF p_stdbor22.v_sttm_bor22_master.product_restriction IS NOT NULL THEN
            IF NVL(p_Wrk_stdbor22.v_sttm_bor22_master.product_restriction,'@') <>
               NVL(p_stdbor22.v_sttm_bor22_master.product_restriction,'@')  THEN
               l_Modified_Flds := l_Modified_Flds ||'~'||l_Fld;
               l_Rec_Modified := TRUE;
            END IF;
         END IF;
      END IF;

      l_Modified_Flds := LTRIM(l_Modified_Flds,'~');
      IF  l_Rec_Modified THEN
         IF l_Modified_Flds IS NOT NULL THEN
            i :=  1;
            l_Mod_Fld := Cspkes_Misc.fn_GetParam(l_modified_flds,i,'~');
            WHILE l_Mod_Fld <> 'EOPL' LOOP
               Pr_Log_Error(p_Source,'ST-AMND-002','@'||l_Mod_Fld||'~@'||l_Blk) ;
               i := i +1;
               l_Mod_Fld := Cspkes_Misc.fn_GetParam(l_Modified_Flds,i,'~');
            END LOOP;
         END IF;
      END IF;
      l_Blk := 'STTM_BOR22_DETAIL';
      l_Count      := p_stdbor22.v_sttm_bor22_detail.COUNT;
      l_Wrk_Count  := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
      IF l_Count > 0 THEN
         FOR l_index IN 1..l_Count  LOOP
            l_Rec_Found := FALSE;
            l_Rec_Modified := FALSE;
            l_Modified_Flds := NULL;
            IF l_Wrk_Count > 0 THEN
               FOR l_index1 IN 1..l_Wrk_Count  LOOP
                  IF (NVL(p_stdbor22.v_sttm_bor22_detail(l_index).product_code,'@')=  NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_index1).product_code,'@')) THEN
                     Dbg('Record Found..');
                     l_Rec_Found := TRUE;

                     l_Modified_Flds := LTRIM(l_Modified_Flds,'~');
                     IF  l_Rec_modified THEN
                        IF l_Modified_Flds IS NOT NULL THEN
                           l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                           p_stdbor22.v_sttm_bor22_detail(l_index).product_code;
                           i :=  1;
                           l_Mod_Fld := Cspkes_Misc.Fn_GetParam(l_Modified_Flds,i,'~');
                           WHILE l_mod_fld <> 'EOPL' LOOP
                              Pr_Log_Error(p_Source,'ST-AMND-003','@'||l_Mod_Fld||'~@'||l_Blk||'~'||l_Key );
                              i := i +1;
                              l_Mod_Fld := Cspkes_Misc.Fn_GetParam(l_Modified_Flds,i,'~');
                           END LOOP;
                        END IF;
                     END IF;
                  END IF;
               END LOOP;
            END IF;
            IF NOT l_Rec_Found THEN
               p_Wrk_stdbor22.v_sttm_bor22_detail(p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT +1 ) :=  p_stdbor22.v_sttm_bor22_detail(l_index);
               IF l_Amendable_Nodes.EXISTS('STTM_BOR22_DETAIL') THEN
                  IF l_Amendable_Nodes('STTM_BOR22_DETAIL').New_Allowed = 'N' THEN
                     Dbg('New Record Cannot Be Added..');
                     l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                     p_stdbor22.v_sttm_bor22_detail(l_index).product_code;
                     Pr_Log_Error(p_source,'ST-AMND-004',l_key||'~@'||l_blk);
                  END IF;
               ELSE
                  Dbg('New Record Cannot Be Added..');
                  l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                  p_stdbor22.v_sttm_bor22_detail(l_index).product_code;
                  Pr_Log_Error(p_Source,'ST-AMND-004',l_key||'~@'||l_blk);
               END IF;
            END IF;
         END LOOP;
      END IF;

      IF l_Amendable_Nodes.EXISTS('STTM_BOR22_DETAIL') THEN
         IF l_Amendable_Nodes('STTM_BOR22_DETAIL').All_Records = 'Y' THEN
            Dbg('Logic For Deleting Some Records From Work Record  if Not sent..');
            l_Wrk_Count := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
            l_Count     := p_stdbor22.v_sttm_bor22_detail.COUNT;
            IF l_Wrk_Count > 0 THEN
               FOR l_index1 IN 1..l_Wrk_count  LOOP
                  l_Rec_Found := FALSE;
                  IF l_Count > 0 THEN
                     FOR l_index IN 1..l_Count  LOOP
                        IF (NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_index1).product_code,'@')=  NVL(p_stdbor22.v_sttm_bor22_detail  (l_index).product_code,'@')) THEN
                           Dbg('Record Found..');
                           l_Rec_Found := TRUE;
                           EXIT;
                        END IF;
                     END LOOP;
                  END IF;
                  IF l_Rec_Found THEN
                     Dbg('Adding  a Record...');
                     N_v_sttm_bor22_detail(N_v_sttm_bor22_detail.COUNT +1 ) :=  p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index1);
                  ELSE
                     l_Deleted_Recs := l_Deleted_Recs +1;
                     IF l_Amendable_Nodes.EXISTS('STTM_BOR22_DETAIL') THEN
                        IF l_Amendable_Nodes('STTM_BOR22_DETAIL').Delete_Allowed = 'N' THEN
                           Dbg('Record Cannot Be Deleted..');
                           l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                           p_Wrk_stdbor22.v_sttm_bor22_detail(l_index1).product_code;
                           Pr_Log_Error(p_Source,'ST-AMND-006',l_Key||'~@'||l_Blk);
                        END IF;
                     ELSE
                        Dbg('Record Cannot Be Deleted..');
                        l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                        p_Wrk_stdbor22.v_sttm_bor22_detail(l_index1).product_code;
                        Pr_Log_Error(p_Source,'ST-AMND-006',l_Key||'~@'||l_Blk);
                     END IF;
                  END IF;
               END LOOP;
            END IF;
            p_Wrk_stdbor22.v_sttm_bor22_detail:= N_v_sttm_bor22_detail;
         END IF;
      END IF;

      Dbg('Returning Success From Fn_Sys_Merge_Amendables..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Merge_Amendables..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Merge_Amendables;

   FUNCTION Fn_Sys_Check_Mandatory_Nodes  (p_Source            IN VARCHAR2,
      p_Wrk_stdbor22 IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Count          NUMBER:= 0;
      l_Base_Data_From_Fc  VARCHAR2(1):= 'Y';
      l_Blk            VARCHAR2(100);
      l_Fld            VARCHAR2(100);
   BEGIN

      dbg('In Fn_Gen_Sys_Node_Mand_Checks..');
      Dbg('Returning Success From Fn_Sys_Check_Mandatory_Nodes..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Check_Mandatory_Nodes..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Check_Mandatory_Nodes;

   FUNCTION Fn_Sys_Lov_Vals        (p_Source            IN VARCHAR2,
      p_Wrk_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Count          NUMBER:= 0;
      l_Key            VARCHAR2(5000):= NULL;
      i                NUMBER := 1;
      l_Lov_Count      NUMBER := 0;
      l_Blk            VARCHAR2(100):= 0;
      l_Fld            VARCHAR2(100):= 0;
      l_Inv_Chr        VARCHAR2(5) :=NULL;
      l_Dsn_Rec_Cnt_1 NUMBER := 0;
      l_Bnd_Cntr_1    NUMBER  := 0;
      l_Dsn_Rec_Cnt_2 NUMBER := 0;
      l_Bnd_Cntr_2    NUMBER  := 0;
   BEGIN

      Dbg('In Fn_Sys_Lov_Vals');
      l_Blk := 'STTM_BOR22_MASTER';
      l_Fld := 'STTM_BOR22_MASTER.CAT';
      IF p_wrk_stdbor22.v_sttm_bor22_master.CAT IS NOT NULL THEN
         SELECT COUNT(*) INTO l_LOV_COUNT  FROM  (SELECT DISTINCT CAT FROM STTM_BOR22_PRODUCT) WHERE CAT = P_wrk_stdbor22.v_sttm_bor22_master.CAT;
         IF l_lov_count = 0  THEN
            Dbg('Invalid Value For The Field  :CAT:'||p_Wrk_stdbor22.v_sttm_bor22_master.CAT);
            Pr_Log_Error(p_Source,'ST-VALS-011',p_Wrk_stdbor22.v_sttm_bor22_master.CAT||'~@STTM_BOR22_MASTER.CAT~@STTM_BOR22_MASTER') ;
         END IF;
      END IF;
      l_Count      := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
      IF l_Count > 0 THEN
         FOR l_Index  IN 1 .. l_Count LOOP
            l_Blk := 'STTM_BOR22_DETAIL';
            l_Fld := 'STTM_BOR22_DETAIL.PRODUCT_CODE';
            IF p_wrk_stdbor22.v_sttm_bor22_detail(l_Index).PRODUCT_CODE IS NOT NULL THEN
               SELECT COUNT(*) INTO l_LOV_COUNT  FROM  (SELECT PRODUCT_CODE FROM STTM_BOR22_PRODUCT WHERE CAT = P_wrk_stdbor22.v_sttm_bor22_master.CAT) WHERE PRODUCT_CODE = P_wrk_stdbor22.v_sttm_bor22_detail(l_Index).PRODUCT_CODE;
               IF l_lov_count = 0  THEN
                  Dbg('Invalid Value For The Field  :PRODUCT_CODE:'||p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index).PRODUCT_CODE);
                  l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_DETAIL.PRODUCT_CODE')||'-'||
                  p_Wrk_stdbor22.v_sttm_bor22_detail(l_index).product_code;
                  Pr_Log_Error(p_Source,'ST-VALS-013',p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index).PRODUCT_CODE||'~@STTM_BOR22_DETAIL.PRODUCT_CODE'||'~'||l_Key||'~@STTM_BOR22_DETAIL') ;
               END IF;
            END IF;
         END LOOP;
      END IF;
      Dbg('Returning Success From Fn_Sys_Lov_Vals..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Lov_Vals..');
         Debug.Pr_debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Lov_Vals;

   FUNCTION Fn_Sys_Default_And_Validate        (p_Source            IN VARCHAR2,
      p_Source_Operation  IN     VARCHAR2,
      p_Function_id       IN     VARCHAR2,
      p_Action_Code       IN     VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Prev_stdbor22 IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22 IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Base_Data_From_Fc  VARCHAR2(1):= 'Y';
      l_Prev_Key_Tags       VARCHAR2(32767);
      l_Prev_Key_Vals       VARCHAR2(32767);
      l_Key  VARCHAR2(32767);
      l_Fld  VARCHAR2(32767);


   BEGIN

      Dbg('In Fn_Sys_Default_and_Validate..');

      IF p_Source <> 'FLEXCUBE'  THEN
         BEGIN
            SELECT Base_Data_From_Fc
            INTO   l_Base_Data_From_Fc
            FROM   Cotms_Source
            WHERE  Source_Code = p_Source;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               Dbg('Failed in Selecting Source '||p_Source);
               Dbg(SQLERRM);
               p_Err_Code    := 'ST-VALS-002';
               p_Err_Params  := p_Source;
               RETURN FALSE;
         END;
      END IF;
      l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.RELATIONSHIP')||'-'||
      p_stdbor22.v_sttm_bor22_master.relationship||':'||
      Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.CAT')||'-'||
      p_stdbor22.v_sttm_bor22_master.cat;
      l_Prev_Key_Tags := 'RELATIONSHIP~'||'CAT~';
      l_Prev_Key_Vals := p_prev_stdbor22.v_sttm_bor22_master.relationship||'~'||p_prev_stdbor22.v_sttm_bor22_master.cat||'~';
      Dbg('Calling Cspks_Req_Utils.Fn_Maint_Basic_Validations..');
      IF NOT Cspks_Req_Utils.Fn_Maint_Basic_Validations (p_source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         p_Prev_stdbor22.v_sttm_bor22_master.Mod_No,
         p_stdbor22.v_sttm_bor22_master.Mod_No,
         p_Prev_stdbor22.v_sttm_bor22_master.Auth_Stat,
         p_Prev_stdbor22.v_sttm_bor22_master.Record_Stat,
         p_Prev_stdbor22.v_sttm_bor22_master.Once_Auth,
         l_Prev_Key_Tags,
         l_Prev_Key_Vals,
         g_Key_Id,
         l_Key,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in Cspks_Req_Utils.Fn_Maint_Basic_Validations..');
         RETURN FALSE;
      END IF;
      IF ( p_Action_Code IN (Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen,Cspks_Req_Global.p_Delete,Cspks_Req_Global.p_Version_Delete,Cspks_Req_Global.p_Query) OR
            ( p_Action_Code = Cspks_Req_Global.p_Modify AND NVL(p_Prev_stdbor22.v_sttm_bor22_master.Once_Auth,'N') = 'Y')) THEN
         p_Wrk_stdbor22 := p_Prev_stdbor22;
         p_wrk_stdbor22.v_sttm_bor22_master.Mod_No := p_stdbor22.v_sttm_bor22_master.Mod_No;
         p_Wrk_stdbor22.Addl_Info := p_stdbor22.Addl_Info ;
      ELSE
         p_Wrk_stdbor22 := p_stdbor22;
      END IF;
      IF p_Action_Code = Cspks_Req_Global.p_Auth THEN
         IF p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No IS NULL THEN
            p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No           := p_prev_stdbor22.v_sttm_bor22_master.Mod_No;
         END IF;
         p_Wrk_stdbor22.v_sttm_bor22_master.Checker_dt_stamp   := fn_mntstamp;
         p_Wrk_stdbor22.v_sttm_bor22_master.Checker_id         := Global.user_id;
      ELSIF p_Action_Code IN (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen) THEN
         p_Wrk_stdbor22.v_sttm_bor22_master.Auth_Stat        := 'U';
         IF NOT Cspks_Req_Global.Fn_UnTanking THEN
            p_Wrk_stdbor22.v_sttm_bor22_master.Maker_Id         := Global.User_Id;
            p_Wrk_stdbor22.v_sttm_bor22_master.Maker_Dt_Stamp   := Fn_Mntstamp;
         ELSE
            p_Wrk_stdbor22.v_sttm_bor22_master.Maker_Id         := NVL(p_stdbor22.v_sttm_bor22_master.Maker_Id,Global.User_Id);
            p_Wrk_stdbor22.v_sttm_bor22_master.Maker_Dt_Stamp   := NVL(p_stdbor22.v_sttm_bor22_master.Maker_Dt_Stamp,Fn_Mntstamp);
         END IF;

         IF p_Action_Code = Cspks_Req_Global.p_New THEN
            IF NOT Cspks_Req_Global.Fn_UnTanking THEN
               p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No           := 1;
            ELSE
               p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No := NVL(p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No,1);
            END IF;
            p_Wrk_stdbor22.v_sttm_bor22_master.Record_Stat      := 'O';
            p_Wrk_stdbor22.v_sttm_bor22_master.Once_Auth        := 'N';
         ELSE
            IF NOT Cspks_Req_Global.Fn_UnTanking THEN
               p_wrk_stdbor22.v_sttm_bor22_master.Mod_No           := NVL(p_prev_stdbor22.v_sttm_bor22_master.Mod_No,0)+1;
            ELSE
               p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No           := NVL(p_stdbor22.v_sttm_bor22_master.Mod_No,1);
            END IF;
            p_Wrk_stdbor22.v_sttm_bor22_master.Once_Auth           := NVL(p_Prev_stdbor22.v_sttm_bor22_master.Once_Auth,'N');
            p_wrk_stdbor22.v_sttm_bor22_master.Record_Stat           := NVL(p_prev_stdbor22.v_sttm_bor22_master.Record_Stat,'O');
         END IF;
         IF p_Action_Code = Cspks_Req_Global.p_Close THEN
            p_Wrk_stdbor22.v_sttm_bor22_master.Record_Stat      := 'C';
         ELSIF p_Action_Code = Cspks_Req_Global.p_Reopen THEN
            p_Wrk_stdbor22.v_sttm_bor22_master.Record_Stat      := 'O';
         END IF;
         p_Wrk_stdbor22.v_sttm_bor22_master.Checker_id         := Null;
         p_Wrk_stdbor22.v_sttm_bor22_master.Checker_Dt_Stamp         := Null;
      ELSIF p_Action_Code IN ( Cspks_Req_Global.p_Delete,Cspks_Req_Global.p_Version_Delete) THEN
         IF p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No IS NULL THEN
            p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No           := p_Prev_stdbor22.v_sttm_bor22_master.Mod_No;
         END IF;
      END IF;
      IF p_Action_Code in  (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify) THEN
         Dbg('Calling .Fn_Sys_Basic_Vals..');
         IF NOT Fn_Sys_Basic_Vals(p_Source,
            p_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in .Fn_Sys_Basic_Vals..');
            RETURN FALSE;
         END IF;

         IF p_Action_Code = Cspks_Req_Global.p_New OR  ( p_Action_Code = Cspks_Req_Global.p_Modify AND p_Prev_stdbor22.v_sttm_bor22_master.Once_Auth = 'N') THEN
            Dbg('Calling .Fn_Sys_Default_Vals..');
            IF NOT Fn_Sys_Default_Vals(p_Source,
               p_Wrk_stdbor22,
               p_Err_Code,
               p_Err_Params)  THEN
               Dbg('Failed in .Fn_Sys_Default_Vals..');
               RETURN FALSE;
            END IF;

         END IF;
         IF p_Action_Code = Cspks_Req_Global.p_Modify AND p_Prev_stdbor22.v_sttm_bor22_master.Once_Auth = 'Y'THEN
            Dbg('Calling Fn_Sys_Merge_Amendables..');
            IF NOT Fn_Sys_Merge_Amendables(p_Source,
               p_Source_Operation,
               p_stdbor22,
               p_Prev_stdbor22,
               p_Wrk_stdbor22,
               p_Err_Code,
               p_Err_Params)  THEN
               Dbg('Failed in .Fn_Sys_Merge_Amendables..');
               RETURN FALSE;
            END IF;
         END IF;

         Dbg('Calling .Fn_Sys_Check_Mandatory_Nodes..');
         IF NOT Fn_Sys_Check_Mandatory_Nodes(p_source,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in .Fn_Sys_Check_Mandatory_Nodes..');
            RETURN FALSE;
         END IF;

         Dbg('Calling  .Fn_Sys_Lov_Vals..');
         IF NOT Fn_Sys_Lov_Vals(p_source,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in .Fn_Sys_Lov_Vals..');
            RETURN FALSE;
         END IF;

      END IF;
      Dbg('Returning Success  From Fn_Sys_Default_And_Validate..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Sys_Default_And_Validate ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Default_And_Validate;
   FUNCTION Fn_Sys_Query_Desc_Fields  ( p_Source    IN  VARCHAR2,
                              p_Source_operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Wrk_stdbor22  IN   OUT stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS
      l_Key            VARCHAR2(5000):= NULL;
      l_Count          NUMBER := 0;
      l_Key_Tags       VARCHAR2(32767);
      l_Key_Vals       VARCHAR2(32767);
      l_Rec_Exists     BOOLEAN := TRUE;
      l_Dsn_Rec_Cnt_2 NUMBER := 0;
      l_Bnd_Cntr_2    NUMBER := 0;
   BEGIN
      Dbg('In Fn_Sys_Query_Desc_Fields..');
      Dbg('Returning Success From Fn_Sys_Query_Desc_Fields..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Query_Desc_Fields ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Query_Desc_Fields;
   FUNCTION Fn_Sys_Query  ( p_Source    IN  VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Full_Data     IN  VARCHAR2 DEFAULT 'Y',
      p_With_Lock     IN  VARCHAR2 DEFAULT 'N',
      p_QryData_Reqd       IN  VARCHAR2,
      p_stdbor22         IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22  IN   OUT stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS
      l_Key            VARCHAR2(5000):= NULL;
      l_Count          NUMBER := 0;
      l_Wrk_Count          NUMBER := 0;
      l_Key_Tags       VARCHAR2(32767);
      l_Key_Vals       VARCHAR2(32767);
      l_Rec_Exists        BOOLEAN := TRUE;
      RECORD_LOCKED    EXCEPTION;
      PRAGMA EXCEPTION_INIT( RECORD_LOCKED, -54 );
      l_Dsn_Rec_Cnt_1 NUMBER := 0;
      l_Bnd_Cntr_1    NUMBER := 0;
      l_Dsn_Rec_Cnt_2 NUMBER := 0;
      l_Bnd_Cntr_2    NUMBER := 0;
      Cursor c_v_sttm_bor22_detail IS
      SELECT *
      FROM   STTM_BOR22_DETAIL
      WHERE cat = p_wrk_stdbor22.v_sttm_bor22_master.cat
       AND relationship = p_wrk_stdbor22.v_sttm_bor22_master.relationship
      ;
   BEGIN
      Dbg('In Fn_Sys_Query..');
      IF p_QryData_Reqd = 'Q' THEN
         Dbg('Calling  Fn_Sys_Query_Desc_Fields..');
         IF NOT Fn_Sys_Query_Desc_Fields (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_Wrk_stdbor22,
            p_Err_Code  ,
            p_Err_Params ) THEN
            Dbg('Failed in Fn_Sys_Query_Desc_Fields..');
            RETURN FALSE;
         END IF;
      ELSE
         l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.RELATIONSHIP')||'-'||
         p_stdbor22.v_sttm_bor22_master.relationship||':'||
         Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.CAT')||'-'||
         p_stdbor22.v_sttm_bor22_master.cat;
         Dbg('Get The Master Record...');
         IF NVL(p_With_Lock,'N') = 'Y' THEN
            BEGIN
               SELECT *
               INTO   p_wrk_stdbor22.v_sttm_bor22_master
               FROM  STTM_BOR22_MASTER
               WHERE relationship = p_stdbor22.v_sttm_bor22_master.relationship
                AND cat = p_stdbor22.v_sttm_bor22_master.cat
                FOR UPDATE NOWAIT;
            EXCEPTION
               WHEN RECORD_LOCKED THEN
                  Dbg('Failed to Obtain the Lock..');
                  Pr_Log_Error(p_Source,'ST-LOCK-001',NULL);
                  RETURN FALSE;
               WHEN No_Data_Found THEN
                  Dbg('Failed in Selecting The Master Recotrd..');
                  Dbg('Record Does not Exist..');
                  l_Rec_Exists := FALSE;
            END;

         ELSE
            BEGIN
               SELECT *
               INTO   p_Wrk_stdbor22.v_sttm_bor22_master
               FROM  STTM_BOR22_MASTER
               WHERE relationship = p_stdbor22.v_sttm_bor22_master.relationship
                AND cat = p_stdbor22.v_sttm_bor22_master.cat
               ;
            EXCEPTION
               WHEN no_data_found THEN
                  Dbg('Failed in Selecting The Master Recotrd..');
                  Dbg('Record Does not Exist..');
                  p_Err_Code    := 'ST-VALS-002';
                  p_Err_Params  := l_Key;
                  RETURN FALSE;
            END;

         END IF;
         IF p_Full_Data = 'Y' AND l_Rec_Exists THEN
            Dbg('Get the Record For :STTM_BOR22_MASTER');
            BEGIN
               SELECT *
               INTO p_Wrk_stdbor22.v_sttm_bor22_master
               FROM   STTM_BOR22_MASTER
               WHERE relationship = p_wrk_stdbor22.v_sttm_bor22_master.relationship
                AND cat = p_wrk_stdbor22.v_sttm_bor22_master.cat
               ;
            EXCEPTION
               WHEN OTHERS THEN
                  Dbg(SQLERRM);
                  Dbg('Failed in Selecting The Record For :STTM_BOR22_MASTER');
            END;
            Dbg('Get the Record For :STTM_BOR22_DETAIL');
            OPEN c_v_sttm_bor22_detail;
            LOOP
               FETCH c_v_sttm_bor22_detail
               BULK COLLECT INTO p_Wrk_stdbor22.v_sttm_bor22_detail;
                EXIT WHEN c_v_sttm_bor22_detail%NOTFOUND;
            END LOOP;
            CLOSE c_v_sttm_bor22_detail;

         END IF;
         IF p_QryData_Reqd = 'Y' THEN
            Dbg('Calling  Fn_Sys_Query_Desc_Fields..');
            IF NOT Fn_Sys_Query_Desc_Fields (p_Source,
               p_Source_Operation,
               p_Function_Id,
               p_Action_Code,
               p_Wrk_stdbor22,
               p_Err_Code  ,
               p_Err_Params ) THEN
               Dbg('Failed in Fn_Sys_Query_Desc_Fields..');
               RETURN FALSE;
            END IF;
         END IF;

      END IF;
      Dbg('Returning Success From Fn_Sys_Query..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Query ..');
         Debug.Pr_Debug('**',SQLERRM);
         IF  c_v_sttm_bor22_detail%ISOPEN THEN
            CLOSE c_v_sttm_bor22_detail;
         END IF;
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Query;
   FUNCTION Fn_Sys_Upload_Db         (p_Source            IN VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Prev_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22      IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Count             NUMBER:= 0;
      l_Ins_Count         NUMBER:= 0;
      l_Upd_Count         NUMBER:= 0;
      l_Del_Count         NUMBER:= 0;
      l_Wrk_Count         NUMBER:= 0;
      l_Prev_Count        NUMBER:= 0;
      l_Rec_Found         BOOLEAN:= FALSE;
      l_Row_Id            ROWID;
      l_Key               VARCHAR2(5000):= NULL;
      l_Auth_Stat         VARCHAR2(1) := 'A';
      l_Base_Data_From_Fc VARCHAR2(1):= 'Y';
      I_v_sttm_bor22_detail       stpks_stdbor22_Main.Ty_Tb_v_sttm_bor22_detail;
      U_v_sttm_bor22_detail       stpks_stdbor22_Main.Ty_Tb_v_sttm_bor22_detail;
      D_v_sttm_bor22_detail       stpks_stdbor22_Main.Ty_Tb_v_sttm_bor22_detail;
   BEGIN
      Dbg('In Fn_Sys_Upload_Db..');
      IF p_Action_Code = Cspks_Req_Global.p_new THEN

         Dbg('Inserting Into STTM_BOR22_MASTER..');
         BEGIN
            IF  p_wrk_stdbor22.v_sttm_bor22_master.relationship IS NOT NULL AND  p_wrk_stdbor22.v_sttm_bor22_master.cat IS NOT NULL THEN
               Dbg('Record Sent..');
               INSERT INTO  STTM_BOR22_MASTER
               VALUES p_wrk_stdbor22.v_sttm_bor22_master;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Dbg('Failed In Insert intoSTTM_BOR22_MASTER..');
               Dbg(SQLERRM);
               p_Err_Code    := 'ST-UPLD-001';
               p_Err_Params  := '@STTM_BOR22_MASTER';
               RETURN FALSE;
         END;

         Dbg('Inserting Into STTM_BOR22_DETAIL..');
         BEGIN
            l_Count      := p_wrk_stdbor22.v_sttm_bor22_detail.COUNT;
            FORALL l_index IN  1..l_count
            INSERT INTO STTM_BOR22_DETAIL
            VALUES p_wrk_stdbor22.v_sttm_bor22_detail(l_index);
         EXCEPTION
            WHEN OTHERS THEN
               Dbg('Failed In Insert intoSTTM_BOR22_DETAIL..');
               Dbg(SQLERRM);
               p_Err_Code    := 'ST-UPLD-001';
               p_Err_Params  := '@STTM_BOR22_DETAIL';
               RETURN FALSE;
         END;
      ELSIF p_Action_Code = Cspks_Req_Global.p_modify THEN

         Dbg('Updating Single Record Node :  STTM_BOR22_MASTER..');
         BEGIN
            UPDATE STTM_BOR22_MASTER
            SET
            DESCRIPT = p_Wrk_stdbor22.v_sttm_bor22_master.DESCRIPT,
            PRODUCT_RESTRICTION = p_Wrk_stdbor22.v_sttm_bor22_master.PRODUCT_RESTRICTION,
            MAKER_ID = p_Wrk_stdbor22.v_sttm_bor22_master.MAKER_ID,
            MAKER_DT_STAMP = p_Wrk_stdbor22.v_sttm_bor22_master.MAKER_DT_STAMP,
            CHECKER_ID = p_Wrk_stdbor22.v_sttm_bor22_master.CHECKER_ID,
            CHECKER_DT_STAMP = p_Wrk_stdbor22.v_sttm_bor22_master.CHECKER_DT_STAMP,
            MOD_NO = p_Wrk_stdbor22.v_sttm_bor22_master.MOD_NO,
            RECORD_STAT = p_Wrk_stdbor22.v_sttm_bor22_master.RECORD_STAT,
            AUTH_STAT = p_Wrk_stdbor22.v_sttm_bor22_master.AUTH_STAT,
            ONCE_AUTH = p_Wrk_stdbor22.v_sttm_bor22_master.ONCE_AUTH
WHERE relationship = p_Wrk_stdbor22.v_sttm_bor22_master.relationship
 AND cat = p_Wrk_stdbor22.v_sttm_bor22_master.cat
;
         EXCEPTION
            WHEN OTHERS THEN
               Dbg('Failed in Insert Into STTM_BOR22_MASTER..');
               Dbg(SQLERRM);
               p_Err_Code    := 'ST-UPLD-001';
               p_Err_Params  := '@STTM_BOR22_MASTER';
               RETURN FALSE;
         END;


         Dbg('Preapring Insert and Update Types for  STTM_BOR22_DETAIL..');
         l_Wrk_Count  := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
         l_Prev_Count := p_Prev_stdbor22.v_sttm_bor22_detail.COUNT;
         IF l_Wrk_Count > 0 THEN
            FOR l_index IN 1 .. l_Wrk_Count LOOP
               l_Rec_Found    := FALSE;
               IF l_Prev_Count >  0 THEN
                  FOR l_index1 IN 1..l_Prev_Count  LOOP
                     IF (NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_index).product_code,'@')=  NVL(p_Prev_stdbor22.v_sttm_bor22_detail  (l_index1).product_code,'@')) THEN
                        Dbg('Record Has Been Found.Update Case..');
                        l_rec_found := TRUE;
                        EXIT;
                     END IF;
                  END LOOP;
               END IF;
               IF l_rec_found THEN
                  Dbg('Record is Modified...');
                  U_v_sttm_bor22_detail(U_v_sttm_bor22_detail.COUNT +1 ) :=  p_Wrk_stdbor22.v_sttm_bor22_detail(l_index);
               ELSE
                  Dbg('Record is Added...');
                  I_v_sttm_bor22_detail(I_v_sttm_bor22_detail.COUNT +1 ) :=  p_Wrk_stdbor22.v_sttm_bor22_detail(l_index);
               END IF;
            END LOOP;
         END IF;

         Dbg('Preapring Delete Types for  STTM_BOR22_DETAIL..');
         l_Wrk_Count  := p_wrk_stdbor22.v_sttm_bor22_detail.COUNT;
         l_Prev_Count := p_prev_stdbor22.v_sttm_bor22_detail.COUNT;
         IF l_Prev_Count > 0 THEN
            FOR l_index1 IN 1 .. l_Prev_Count LOOP
               l_Rec_Found    := FALSE;
               IF l_Wrk_Count >  0 THEN
                  FOR l_index IN 1..l_Wrk_Count  LOOP
                     IF (NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_index).product_code,'@')=  NVL(p_Prev_stdbor22.v_sttm_bor22_detail  (l_index1).product_code,'@')) THEN
                        Dbg('Record Has Been Found.Update Case..');
                        l_Rec_Found := TRUE;
                        EXIT;
                     END IF;
                  END LOOP;
               END IF;
               IF NOT l_Rec_Found THEN
                  Dbg('Record is Deleted...');
                  D_v_sttm_bor22_detail(D_v_sttm_bor22_detail.COUNT +1 ) :=  p_Prev_stdbor22.v_sttm_bor22_detail(l_index1);
               END IF;
            END LOOP;
         END IF;
         l_Del_Count  := D_v_sttm_bor22_detail.COUNT;
         Dbg('Records Deleted  :'||l_Del_Count);
         IF l_Del_Count > 0 THEN
            FOR l_index IN 1 .. l_del_count LOOP
               Dbg('Deleting Record...');
               DELETE STTM_BOR22_DETAIL
               WHERE product_code = D_v_sttm_bor22_detail(l_index).product_code
                AND relationship = D_v_sttm_bor22_detail(l_index).relationship
                AND cat = D_v_sttm_bor22_detail(l_index).cat
               ;
            END LOOP;
         END IF;
         l_Ins_Count  := I_v_sttm_bor22_detail.COUNT;
         Dbg('New Records Added  :'||l_ins_count);
         BEGIN
            l_Count      := I_v_sttm_bor22_detail.COUNT;
            FORALL l_Index IN  1..l_count
            INSERT INTO STTM_BOR22_DETAIL
            VALUES I_v_sttm_bor22_detail(l_index);
         EXCEPTION
            WHEN OTHERS THEN
               Dbg('Failed in Insert IntoSTTM_BOR22_DETAIL..');
               Dbg(SQLERRM);
               p_Err_Code    := 'ST-UPLD-001';
               p_Err_Params  := '@STTM_BOR22_DETAIL';
               RETURN FALSE;
         END;
      ELSIF p_Action_Code = Cspks_Req_Global.p_delete THEN
         Dbg('Action Code '||p_Action_Code);
         Dbg('Deleting The Data..');

         
         DELETE STTM_BOR22_DETAIL
         WHERE cat = p_Wrk_stdbor22.v_sttm_bor22_master.cat
          AND relationship = p_Wrk_stdbor22.v_sttm_bor22_master.relationship
         ;

         DELETE STTM_BOR22_MASTER WHERE relationship = p_Wrk_stdbor22.v_sttm_bor22_master.relationship
          AND cat = p_Wrk_stdbor22.v_sttm_bor22_master.cat
         ;


      ELSIF p_Action_Code IN (Cspks_Req_Global.p_Auth,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen ) THEN
         l_key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.RELATIONSHIP')||'-'||
         p_Wrk_stdbor22.v_sttm_bor22_master.relationship||':'||
         Cspks_Req_Utils.Fn_Get_Item_Desc(p_source,g_ui_name,'STTM_BOR22_MASTER.CAT')||'-'||
         p_Wrk_stdbor22.v_sttm_bor22_master.cat;
         BEGIN
            SELECT ROWID
            INTO   l_row_id
            FROM  STTM_BOR22_MASTER
            WHERE relationship = p_Wrk_stdbor22.v_sttm_bor22_master.relationship
             AND cat = p_Wrk_stdbor22.v_sttm_bor22_master.cat
            ;
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Previous Master Recotrd..');
               p_Err_Code    := 'ST-VALS-002';
               p_Err_Params  := l_key;
               RETURN FALSE;
         END;

         IF NOT Cspks_Req_Utils.Fn_Maint_Operations(p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            'STTM_BOR22_MASTER',
            l_Row_Id,
            p_Wrk_stdbor22.v_sttm_bor22_master.mod_no,
            p_Wrk_stdbor22.v_sttm_bor22_master.Maker_dt_Stamp,
            p_Wrk_stdbor22.v_sttm_bor22_master.Checker_dt_Stamp,
            g_Key_Id,
            l_Key,
            p_Err_Code,
            p_Err_params) THEN
            Dbg('Failed in Cspks_Req_Utils.Fn_Maint_Basic_Validations');
            RETURN FALSE;
         END IF;

      END IF;

      Dbg('Returning Success From Fn_Sys_Upload_Db');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Sys_Upload_Db ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_params  := NULL;
         RETURN FALSE;
   END Fn_Sys_Upload_Db;
   FUNCTION Fn_Build_Type (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Addl_Info       IN Cspks_Req_Global.Ty_Addl_Info,
      p_stdbor22       IN   OUT stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_Main_Function Smtb_Menu.Function_Id%TYPE := p_Function_Id;
      l_Child_Function Smtb_Menu.Function_Id%TYPE := p_Function_Id;

   BEGIN

      Dbg('In Fn_Build_Ws_Type..');

      IF Cspks_Req_Utils.Fn_Is_Req_Fc_Format(p_Source,p_Function_Id) THEN
         IF NOT Fn_Sys_Build_Fc_Type(p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_Addl_Info ,
            p_STDBOR22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_Sys_Build_Fc_Type..');
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Sys_Build_Ws_Type(p_source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_Addl_Info ,
            p_STDBOR22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_Sys_Build_Ws_Type..');
            RETURN FALSE;
         END IF;
      END IF;
      Pr_Skip_Handler('POSTTYPE');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Post_Build_Type_Structure(p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            l_Child_Function,
            p_Addl_Info ,
            p_STDBOR22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Build_Type_Structure..');
            RETURN FALSE;
         END IF;
      END IF;
      Dbg('Returning Success From Fn_Build_Type..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Build_Type ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Build_Type;
   FUNCTION Fn_Build_Ts_List (p_source    IN     VARCHAR2,
                              p_source_operation  IN     VARCHAR2,
                              p_Function_id       IN     VARCHAR2,
                              p_action_code       IN     VARCHAR2,
      p_exchange_pattern   IN  VARCHAR2,
      p_stdbor22          IN stpks_stdbor22_Main.ty_stdbor22,
      p_err_code        IN OUT VARCHAR2,
      p_err_params      IN OUT VARCHAR2)
   RETURN BOOLEAN   IS

      l_Main_Function smtb_menu.function_id%TYPE := p_Function_id;

   BEGIN

      dbg('In Fn_Build_Ts_List..');

      IF Cspks_Req_Utils.Fn_Is_Res_Fc_Format(p_source,p_Function_id) THEN
         IF NOT  Fn_Sys_Build_Fc_Ts(p_Source,
            p_source_operation,
            p_Function_id,
            p_action_code,
            p_stdbor22,
            p_err_code,
            p_err_params)  THEN
            dbg('Failed in Fn_Sys_Build_Fc_Ts');
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT  Fn_Sys_Build_Ws_Ts(p_Source,
            p_source_operation,
            p_Function_id,
            p_action_code,
            p_exchange_pattern,
            p_stdbor22,
            p_err_code,
            p_err_params)  THEN
            dbg('Failed in Fn_Sys_Build_Ws_Ts');
            RETURN FALSE;
         END IF;
      END IF;

      dbg('Returning from Fn_Build_Ts_List');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         debug.pr_debug('**','In when others of stpks_stdbor22_Main.Fn_Build_Ts_List ..');
         debug.pr_debug('**',SQLERRM);
         p_err_code    := 'ST-OTHR-001';
         p_err_params  := NULL;
         RETURN FALSE;
   END Fn_Build_Ts_List;
   FUNCTION Fn_Get_Key_Information (p_Source    IN  VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_stdbor22       IN  OUT stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Key_Cols        VARCHAR2(32767);
      l_Key_Vals        VARCHAR2(32767);
      l_Func_Type       VARCHAR2(32767);
   BEGIN

      Dbg('In Fn_Get_Key_Information..');
      l_Key_Cols := 'RELATIONSHIP~'||'CAT~';
      l_Key_Vals := p_stdbor22.v_sttm_bor22_master.relationship||'~'||p_stdbor22.v_sttm_bor22_master.cat||'~';
      Dbg('Calling Cspks_Req_Utils.Fn_Get_Key_Information..');
      IF NOT Cspks_Req_Utils.Fn_Get_Key_Information(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code ,
         'FCCMAINTENANCE',
         'STTM_BOR22_MASTER',
         'BLK_MAIN',
         'Main',
         l_Key_Cols,
         l_Key_Vals,
         p_stdbor22.Addl_Info,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in  Cspks_Req_Utils.Fn_Get_Key_Information..');
         RETURN FALSE;
      END IF;
      IF p_stdbor22.Addl_Info.EXISTS('RECORD_KEY') THEN
         G_Req_Key :=  p_stdbor22.Addl_Info('RECORD_KEY');
      END IF;
      IF p_stdbor22.Addl_Info.EXISTS('KEY_ID') THEN
         G_Key_Id :=  p_stdbor22.Addl_Info('KEY_ID');
      END IF;
      p_stdbor22.Addl_Info('SENT_MOD_NO') :=p_stdbor22.v_sttm_bor22_master.Mod_No;
      Dbg('Returning Succsess From Fn_Get_Key_Information..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Get_Key_Information..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Get_Key_Information;
   FUNCTION Fn_Check_Mandatory (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Pk_Or_Full     IN  VARCHAR2 DEFAULT 'FULL',
      p_stdbor22 IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code       IN  OUT VARCHAR2,
      p_Err_Params     IN  OUT VARCHAR2)
     RETURN BOOLEAN IS

      l_Pk_Or_Full      VARCHAR2(10) :=  'FULL';
      l_Blk      VARCHAR2(100) ;
      l_Fld      VARCHAR2(100) ;
      l_Main_Function Smtb_Menu.Function_Id%TYPE := p_Function_Id;
      l_Source_Operation      VARCHAR2(100) := p_Source_Operation;

   BEGIN

      Dbg('In Fn_Check_Mandatory..');

      IF p_Pk_Or_Full = 'FULL' OR p_Action_Code = Cspks_Req_Global.p_New THEN
         l_Pk_Or_Full := 'FULL';
      ELSE
         l_Pk_Or_Full := p_Pk_Or_Full;
      END IF;
      Pr_Skip_Handler('PREMAND');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Pre_Check_Mandatory (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_function_Id  ,
            p_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in  stpks_stdbor22_Custom.Fn_Pre_Check_Mandatory..');
            RETURN FALSE;
         END IF;
      END IF;

      IF NOT stpks_stdbor22_Main.Fn_Skip_Sys THEN
         Dbg('Calling   Fn_Sys_Check_Mandatory..');
         IF NOT Fn_Sys_Check_Mandatory(p_Source,
            l_Pk_Or_Full,
            p_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_Sys_Check_Mandatory..');
            RETURN FALSE;
         END IF;
      END IF;

      Pr_Skip_Handler('POSTMAND');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Post_Check_Mandatory (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_function_Id  ,
            l_Pk_Or_Full,
            p_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in  stpks_stdbor22_Custom.Fn_Post_Check_Mandatory..');
            RETURN FALSE;
         END IF;
      END IF;
      Dbg('Returning Success From Fn_Check_Mandatory..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Check_Mandatory ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Check_Mandatory;
   FUNCTION Fn_Query  ( p_Source    IN  VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Full_Data     IN  VARCHAR2 DEFAULT 'Y',
      p_With_Lock     IN  VARCHAR2 DEFAULT 'N',
      p_QryData_Reqd       IN  VARCHAR2,
      p_stdbor22         IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22  IN   OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_Key_Vals VARCHAR2(32767);
      l_Tanked_data_Found             BOOLEAN := FALSE;
      l_Bld_Type_From_Tanked_Data     BOOLEAN := FALSE;
      l_Mod_No                        NUMBER;
      l_Main_Function Smtb_Menu.Function_Id%TYPE := p_Function_Id;
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_Skip_custom      BOOLEAN := FALSE;

   BEGIN

      Dbg('In Fn_Query..');

      l_Mod_No := p_stdbor22.v_sttm_bor22_master.Mod_No;
      Dbg('Calling Cspks_Req_Utils.Fn_Get_From_Tanked.');
      IF NOT Cspks_Req_Utils.Fn_Get_Tanked_Data (p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         g_Key_Id,
         l_Mod_No,
         NVL(p_With_Lock,'N'),
         l_Tanked_data_Found,
         l_Bld_Type_From_Tanked_Data,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in Cspks_Req_Utils.Fn_Get_From_Tanked.');
         Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
      END IF;

      IF l_Tanked_data_Found THEN
         IF l_Bld_Type_From_Tanked_Data THEN
            IF NOT  Fn_Sys_Build_Fc_Type(p_Source,
               p_Source_Operation,
               p_Function_Id,
               p_Action_Code,
               p_stdbor22.Addl_Info,
               p_Wrk_stdbor22,
               p_Err_Code,
               p_Err_Params)  THEN
               Dbg('Failed in Fn_Sys_Build_Fc_Type..');
               l_Tanked_data_Found      := FALSE;
               Pr_Log_Error(p_Source,'ST-TANK-001',NULL);
            END IF;
            g_Curr_Stage := 'POSTTANKQRY' ;
            l_Skip_custom:= g_Skip_custom;
            stpks_stdbor22_Main.Pr_Set_Skip_custom;
            Pr_Skip_Handler('POSTTANKQRY');
            Dbg('Calling Post Query Hooks After Query Of Tanked Data');
            IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
               IF NOT stpks_stdbor22_Custom.Fn_Post_Query (p_Source,
                  p_Source_operation,
                  p_Function_id,
                  p_Action_Code,
                  p_Function_Id  ,
                  p_Full_Data,
                  p_With_Lock,
                  p_Qrydata_Reqd,
                  p_stdbor22,
                  p_Wrk_stdbor22,
                  p_Err_Code,
                  p_Err_Params) THEN
                  Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Query of Tanked Data');
                  RETURN FALSE;
               END IF;
            END IF;
            g_Skip_custom:= l_Skip_custom;
            g_Curr_Stage := NULL ;
         END IF ;
      ELSE
         Dbg('Query From Base Tables..');
         Pr_Skip_Handler('PREQRY');
         IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
            IF NOT stpks_stdbor22_Custom.Fn_Pre_Query (p_Source,
               p_Source_Operation,
               p_Function_Id,
               p_Action_Code,
               p_function_Id  ,
               p_Full_Data  ,
               p_With_Lock,
               p_QryData_Reqd,
               p_stdbor22,
               p_Wrk_stdbor22,
               p_Err_Code  ,
               p_Err_Params ) THEN
               Dbg('Failed in stpks_stdbor22_Custom.Fn_Pre_Query..');
               RETURN FALSE;
            END IF;
         END IF;
         IF NOT stpks_stdbor22_Main.Fn_Skip_Sys THEN
            IF NOT Fn_Sys_Query (p_Source,
               p_Source_Operation,
               p_Function_Id,
               p_Action_Code,
               p_Full_Data  ,
               p_With_Lock,
               p_QryData_Reqd,
               p_stdbor22,
               p_Wrk_stdbor22,
               p_Err_Code  ,
               p_Err_Params ) THEN
               Dbg('Failed in Fn_Sys_Query..');
               RETURN FALSE;
            END IF;
         END IF;
         Pr_Skip_Handler('POSTQRY');
         IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
            IF NOT stpks_stdbor22_Custom.Fn_Post_Query (p_Source,
               p_Source_Operation,
               p_Function_Id,
               p_Action_Code,
               p_function_Id  ,
               p_Full_Data  ,
               p_With_Lock,
               p_QryData_Reqd,
               p_stdbor22,
               p_Wrk_stdbor22,
               p_Err_Code  ,
               p_Err_Params ) THEN
               Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Query..');
               RETURN FALSE;
            END IF;
         END IF;
      END IF;
      Dbg('Returning Success From Fn_Query..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Query ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Query;
   FUNCTION Fn_Default_And_Validate        (p_Source            IN VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Prev_stdbor22 IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22 IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Main_Function Smtb_Menu.Function_Id%TYPE := p_Function_Id;
      l_Check_Amendables  VARCHAR2(1) := 'N';
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_Full_data    VARCHAR2(1) := 'N';
      l_With_Lock    VARCHAR2(1) := 'Y';
      l_Qrydata_Reqd    VARCHAR2(1) := 'N';
      l_Pk_Or_Full      VARCHAR2(10) := 'FULL';


   BEGIN

      Dbg('In Fn_Default_And_Validate..');

      l_Full_data   := 'Y';
      Dbg('Calling  Fn_Query..');
      IF NOT Fn_Query(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         l_Full_data,
         l_With_Lock,
         l_Qrydata_Reqd,
         p_stdbor22,
         p_Prev_stdbor22,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in Fn_Query..');
         RETURN FALSE;
      END IF;
      Pr_Skip_Handler('PREDFLT');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Pre_Default_And_Validate (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_function_Id  ,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in stpks_stdbor22_Custom.Fn_Pre_Default_And_Validate..');
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT stpks_stdbor22_Main.Fn_Skip_Sys THEN
         Dbg('Calling in Fn_Sys_Default_and_Validate..');
         IF NOT Fn_Sys_Default_and_Validate (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code  ,
            p_Err_Params ) THEN
            Dbg('Failed in Fn_Sys_Default_and_Validate..');
            RETURN FALSE;
         END IF;
      END IF;
      Pr_Skip_Handler('POSTDFLT');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Post_Default_And_Validate (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_function_Id  ,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Default_And_Validate..');
            RETURN FALSE;
         END IF;
      END IF;
      IF p_Action_Code = Cspks_Req_Global.p_Modify THEN
         Dbg('Calling  Fn_Check_Mandatory..');
         IF NOT Fn_Check_Mandatory(p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            l_Pk_Or_Full,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in Fn_Check_Mandatory..');
            RETURN FALSE;
         END IF;
      END IF;
      Dbg('Returning Success From Fn_Default_And_Validate..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Default_And_Validate ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Default_And_Validate;
   FUNCTION Fn_Upload_Db  (p_Source            IN VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
      p_Post_Upl_Stat    IN     VARCHAR2,
      p_Multi_Trip_Id    IN  VARCHAR2,
      p_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Prev_stdbor22     IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Wrk_stdbor22      IN OUT  stpks_stdbor22_Main.Ty_stdbor22,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Main_Function Smtb_Menu.Function_Id%TYPE := p_Function_id;
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_Row_Id            ROWID;
      l_Key  VARCHAR2(32767);
      l_Fld  VARCHAR2(32767);


   BEGIN

      Dbg('In Fn_Upload_Db..');

      Pr_Skip_Handler('PREUPLD');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Pre_Upload_Db (p_Source,
            p_Source_operation,
            p_Function_id,
            p_Action_Code,
            p_function_Id  ,
            p_Post_Upl_Stat,
            p_Multi_Trip_Id,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in stpks_stdbor22_Custom.Fn_Pre_Upload_Db..');
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT stpks_stdbor22_Main.Fn_Skip_Sys THEN
         IF NOT Fn_Sys_Upload_Db (p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in Fn_Pre_Upload_Db..');
            RETURN FALSE;
         END IF;
      END IF;

      Pr_Skip_Handler('POSTUPLD');
      IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
         IF NOT stpks_stdbor22_Custom.Fn_Post_Upload_Db (p_Source,
            p_Source_operation,
            p_Function_id,
            p_Action_Code,
            p_function_Id  ,
            p_Post_Upl_Stat,
            p_Multi_Trip_Id,
            p_stdbor22,
            p_Prev_stdbor22,
            p_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Upload_Db..');
            RETURN FALSE;
         END IF;
      END IF;
      Dbg('Returning Success  From Fn_Upload_Db..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of stpks_stdbor22_Main.Fn_Upload_Db ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Upload_Db;
   FUNCTION Fn_Populate_Record_Master (p_Source            IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_stdbor22          IN  stpks_stdbor22_Main.Ty_stdbor22,
                              p_Record_Master     IN OUT Sttbs_Record_Master%ROWTYPE,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_Summary_Rec     STTM_BOR22_MASTER%ROWTYPE;
      l_Summary_Rec_Found BOOLEAN := TRUE;
   BEGIN

      Dbg('In Fn_Populate_Record_Master..');

      IF  p_Action_Code IN (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen) THEN
         Dbg('Populating Record Master ..');
         IF g_Key_Id IS NOT NULL THEN
            l_Summary_Rec := p_stdbor22.v_sttm_bor22_master;
            IF l_Summary_Rec_Found THEN
               Dbg('Summary Record Found..');
               p_Record_Master.Key_Id := g_Key_Id;
               p_Record_Master.AUTH_STAT := l_Summary_Rec.AUTH_STAT;
               p_Record_Master.RECORD_STAT := l_Summary_Rec.RECORD_STAT;
               p_Record_Master.CHAR_FLD_1 := l_Summary_Rec.CAT;
               p_Record_Master.CHAR_FLD_2 := l_Summary_Rec.DESCRIPT;
               p_Record_Master.CHAR_FLD_3 := l_Summary_Rec.PRODUCT_RESTRICTION;
               p_Record_Master.CHAR_FLD_4 := l_Summary_Rec.RELATIONSHIP;
            END IF;
         END IF;
      END IF;

      Dbg('Returning Success From Fn_Populate_Record_Master..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others Of Fn_Populate_Record_Master ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Populate_Record_Master;

   FUNCTION Fn_Tank_Modification   (p_Source            IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_Tanking_Status    IN OUT VARCHAR2,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

   BEGIN

      Dbg('In Fn_Tank_Modification..');
      p_Tanking_Status := 'N';
      IF Cspks_Req_Utils.Fn_Tank_Modification(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Rolling Back The Modification..');
         p_Tanking_Status := 'T';
         g_Tanking_Status := 'T';
         ROLLBACK TO Sp_Main_Stdbor22;
      END IF;

      Dbg('Returning Success From Fn_Tank_Modification..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Tank_Modification ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Tank_Modification;

   FUNCTION Fn_Maint_Log (p_Source            IN     VARCHAR2,
                              p_Source_Operation IN     VARCHAR2,
                              p_Function_Id      IN     VARCHAR2,
                              p_Action_Code      IN     VARCHAR2,
                              p_Multi_Trip_Id       IN     VARCHAR2,
                              p_Request_No          IN     VARCHAR2,
                              p_Record_Master     IN  Sttbs_Record_Master%ROWTYPE,
                              p_stdbor22          IN  stpks_stdbor22_Main.Ty_stdbor22,
                              p_Prev_stdbor22          IN  stpks_stdbor22_Main.Ty_stdbor22,
                              p_wrk_stdbor22          IN  stpks_stdbor22_Main.Ty_stdbor22,
      p_Tanking_Status IN VARCHAR2,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_Main_Function VARCHAR2(50) := p_Function_id;
      l_Auth_Stat       VARCHAR2(32767):= NULL;
      l_Source_Operation       VARCHAR2(100) := p_Source_Operation;
      l_Key_Id         VARCHAR2(32767):= g_Key_Id;
      l_Mod_No          NUMBER := 1;
      l_Blk             VARCHAR2(32767):= NULL;
      l_Fld             VARCHAR2(32767):= NULL;
      l_Dbt             VARCHAR2(32767):= NULL;
      l_Dbc             VARCHAR2(32767):= NULL;
      l_Rec_Action      VARCHAR2(32767):= 'M';
      l_Dtl_Key          VARCHAR2(32767):= NULL;
      l_Prev_Count      NUMBER := 0;
      l_Wrk_Count      NUMBER := 0;
      l_Count          NUMBER := 0;
      l_Log_Count       NUMBER := 0;
      l_Fld_Count       NUMBER := 0;
      l_Matched_Rec     NUMBER := 0;
      l_Rec_Found       BOOLEAN:= FALSE;
      l_Prev_Found       BOOLEAN:= FALSE;
      l_Wrk_Found       BOOLEAN:= FALSE;
      l_Rec_Modified    BOOLEAN:= FALSE;
      l_Record_log      Sttbs_Record_Log%ROWTYPE;
      l_Field_log       Sttbs_Field_log%ROWTYPE;
      l_wrk_stdbor22      stpks_stdbor22_Main.Ty_stdbor22;
      l_Skip_custom      BOOLEAN := FALSE;
      l_Tb_Field_Log    Cspks_Req_Global.Ty_Tb_Fld_Log;

      PROCEDURE Pr_Log_Change(p_Dbc     IN VARCHAR2,
                                 p_Action  IN VARCHAR2,
                                 p_Old_Val IN VARCHAR2,
                                 p_New_Val IN VARCHAR2) IS
      BEGIN
         IF NVL(p_Old_Val,'@') <> NVL(p_New_Val,'@') THEN
             l_Fld_Count := l_Fld_Count +1;
            l_Log_Count := NVL(l_Tb_Field_Log.COUNT,0) +1;
            l_Field_log.Detail_Key := l_Dtl_Key;
            l_Field_log.Block_Name := l_Blk;
            l_Field_log.Field_Name := p_Dbc;
            l_Field_log.Table_Name := l_Dbt;
            l_Field_log.Item_no := l_Fld_Count;
            l_Field_log.Record_Stat := p_Action;
            IF length(p_Old_Val)>2000 THEN
               l_Field_log.Old_Value := Substr(p_Old_Val,1,2000);
            ELSE
               l_Field_log.Old_Value := p_Old_Val;
            END IF;
            IF length(p_New_Val)>2000 THEN
               l_Field_log.New_Value := Substr(p_New_Val,1,2000);
            ELSE
               l_Field_log.New_Value := p_New_Val;
            END IF;
            l_Tb_Field_Log(l_Log_Count) := l_Field_log;
         END IF;
      END Pr_Log_Change;

   BEGIN

      Dbg('In Fn_Maint_Log');

      IF  p_Action_Code IN (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen,Cspks_Req_Global.p_Auth,Cspks_Req_Global.p_Delete,Cspks_Req_Global.p_Version_Delete) THEN
         Dbg('Maintenance Log is Required ..');
         IF l_Key_Id IS NOT NULL THEN
            IF p_Action_Code IN( Cspks_Req_Global.p_auth,Cspks_Req_Global.p_Delete,Cspks_Req_Global.p_Version_Delete) THEN
               IF p_stdbor22.v_sttm_bor22_master.Mod_no IS NOT NULL THEN
                  l_Mod_No           := p_stdbor22.v_sttm_bor22_master.Mod_No;
               ELSE
                  l_Mod_No           := p_Wrk_stdbor22.v_sttm_bor22_master.Mod_No;
               END IF;
            ELSE
               l_mod_no           := p_wrk_stdbor22.v_sttm_bor22_master.mod_no;
            END IF;
              l_Auth_Stat := NVL(p_Wrk_stdbor22.v_sttm_bor22_master.Auth_Stat,'U') ;
            IF NOT Cspks_Req_Utils.Fn_Maint_Log(p_Source,
                p_Source_Operation  ,
                p_Function_Id ,
                p_Action_Code,
                p_Multi_Trip_Id ,
                p_Request_No ,
               'STTM_BOR22_MASTER',
               l_Key_Id,
               l_Mod_No,
               l_Auth_Stat,
               p_Tanking_Status ,
               p_Record_Master ,
               p_Err_Code,
               p_Err_Params) THEN
               Dbg('Failed in   Cspks_Req_Utils.Fn_Maint_Log..');
               RETURN FALSE;
            END IF;
            IF Cspks_Req_Utils.Fn_Field_Log_Reqd(p_Function_Id,p_Action_Code) THEN
               l_Field_log.Key_id := l_Key_Id;
               l_Field_log.Mod_No := l_Mod_No;
               l_Field_log.Function_id := p_Function_Id;

               l_Dbt := 'STTM_BOR22_MASTER';

               l_Blk := 'STTM_BOR22_MASTER';
               l_Rec_Modified := FALSE;
               l_Prev_Found := FALSE;
               l_Wrk_Found := FALSE;

               IF p_Prev_stdbor22.v_sttm_bor22_master.relationship IS NOT NULL AND p_Prev_stdbor22.v_sttm_bor22_master.cat IS NOT NULL THEN
                  Dbg('Record Has Been Sent..');
                  l_prev_found := TRUE;
               END IF;
               IF p_Wrk_stdbor22.v_sttm_bor22_master.relationship IS NOT NULL AND p_Wrk_stdbor22.v_sttm_bor22_master.cat IS NOT NULL THEN
                  Dbg('Record Has Been Sent..');
                  l_Wrk_Found := TRUE;
               END IF;
               IF l_Prev_Found   THEN
                  l_Dtl_key := '~STTM_BOR22_MASTER~'||p_Prev_stdbor22.v_sttm_bor22_master.relationship||'~'||p_Prev_stdbor22.v_sttm_bor22_master.cat||'~';
               ELSIF l_Wrk_Found   THEN
                  l_Dtl_key := '~STTM_BOR22_MASTER~'||p_Wrk_stdbor22.v_sttm_bor22_master.relationship||'~'||p_Wrk_stdbor22.v_sttm_bor22_master.cat||'~';
               END IF;
               IF l_Wrk_Found  OR l_Prev_Found THEN
                  IF l_Wrk_Found  AND l_Prev_Found THEN
                     l_rec_action := 'M';
                  ELSIF l_wrk_found  AND ( NOT l_Prev_Found) THEN
                     l_Rec_Action := 'N';
                  ELSIF (NOT l_wrk_Found)  AND l_Prev_Found THEN
                     l_Rec_Action := 'D';
                  END IF;
                  Pr_Log_Change('CAT',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.cat,p_Wrk_stdbor22.v_sttm_bor22_master.cat);
Pr_Log_Change('DESCRIPT',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.descript,p_Wrk_stdbor22.v_sttm_bor22_master.descript);
Pr_Log_Change('PRODUCT_RESTRICTION',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.product_restriction,p_Wrk_stdbor22.v_sttm_bor22_master.product_restriction);
Pr_Log_Change('RELATIONSHIP',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.relationship,p_Wrk_stdbor22.v_sttm_bor22_master.relationship);
Pr_Log_Change('MAKER_ID',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.maker_id,p_Wrk_stdbor22.v_sttm_bor22_master.maker_id);
Pr_Log_Change('MAKER_DT_STAMP',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.maker_dt_stamp,p_Wrk_stdbor22.v_sttm_bor22_master.maker_dt_stamp);
Pr_Log_Change('CHECKER_ID',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.checker_id,p_Wrk_stdbor22.v_sttm_bor22_master.checker_id);
Pr_Log_Change('CHECKER_DT_STAMP',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.checker_dt_stamp,p_Wrk_stdbor22.v_sttm_bor22_master.checker_dt_stamp);
Pr_Log_Change('MOD_NO',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.mod_no,p_Wrk_stdbor22.v_sttm_bor22_master.mod_no);
Pr_Log_Change('RECORD_STAT',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.record_stat,p_Wrk_stdbor22.v_sttm_bor22_master.record_stat);
Pr_Log_Change('AUTH_STAT',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.auth_stat,p_Wrk_stdbor22.v_sttm_bor22_master.auth_stat);
Pr_Log_Change('ONCE_AUTH',l_Rec_Action,p_Prev_stdbor22.v_sttm_bor22_master.once_auth,p_Wrk_stdbor22.v_sttm_bor22_master.once_auth);


                              END IF;


               l_Dbt := 'STTM_BOR22_DETAIL';
               l_Blk := 'STTM_BOR22_DETAIL';
               l_Wrk_Count  := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
               l_Prev_Count      := p_Prev_stdbor22.v_sttm_bor22_detail.COUNT;
               IF l_Wrk_count > 0 THEN
                  FOR l_Index IN 1..l_Wrk_count  LOOP
                     l_Dtl_key := '~STTM_BOR22_DETAIL~'||p_wrk_stdbor22.v_sttm_bor22_detail(l_index).product_code||'~'||p_wrk_stdbor22.v_sttm_bor22_detail(l_index).relationship||'~'||p_wrk_stdbor22.v_sttm_bor22_detail(l_index).cat||'~';
                     l_Rec_Found := FALSE;
                     l_Rec_Modified := FALSE;
                     IF l_Prev_count > 0 THEN
                        FOR l_Index1 IN 1..l_Prev_count  LOOP
                           IF (NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index).product_code,'@')=  NVL(p_Prev_stdbor22.v_sttm_bor22_detail(l_Index1).product_code,'@')) THEN
                              Dbg('Record Found..');
                              l_Rec_Found := TRUE;
                              l_Matched_Rec := l_Index1;
                              Pr_Log_Change('PRODUCT_CODE','M',p_Prev_stdbor22.v_sttm_bor22_detail(l_Index1).product_code,p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index).product_code);



                                                      END IF;
                        END LOOP;
                     END IF;
                     IF NOT l_rec_found THEN
                        Dbg('New Record Found..');
                        Pr_Log_Change('PRODUCT_CODE','N',NULL,p_wrk_stdbor22.v_sttm_bor22_detail(l_Index).product_code);


                                          END IF;
                  END LOOP;
               END IF;
               l_Prev_count      := p_Prev_stdbor22.v_sttm_bor22_detail.COUNT;
               l_Wrk_Count  := p_Wrk_stdbor22.v_sttm_bor22_detail.COUNT;
               IF l_Prev_Count > 0 THEN
                  FOR l_Index IN 1..l_Prev_count  LOOP
                     l_Rec_Found := FALSE;
                     l_Rec_Modified := FALSE;
                     IF l_Wrk_Count > 0 THEN
                        FOR l_Index1 IN 1..l_Wrk_Count  LOOP
                           IF (NVL(p_Prev_stdbor22.v_sttm_bor22_detail(l_Index).product_code,'@')=  NVL(p_Wrk_stdbor22.v_sttm_bor22_detail(l_Index1).product_code,'@')) THEN
                              Dbg('Record Found..');
                              l_Rec_Found := TRUE;
                              EXIT;

                           END IF;
                        END LOOP;
                     END IF;
                     IF NOT l_Rec_Found THEN
                        Dbg('Record Deleted..');
                        l_Dtl_key := '~STTM_BOR22_DETAIL~'||p_Prev_stdbor22.v_sttm_bor22_detail(l_Index).product_code||'~'||p_Prev_stdbor22.v_sttm_bor22_detail(l_Index).relationship||'~'||p_Prev_stdbor22.v_sttm_bor22_detail(l_Index).cat||'~';
                        Pr_Log_Change('PRODUCT_CODE','D',p_Prev_stdbor22.v_sttm_bor22_detail(l_Index).product_code,NULL);


                                          END IF;
                  END LOOP;
               END IF;

               l_Count      := l_Tb_Field_Log.COUNT;
               IF l_Count   > 0 THEN
                  Dbg('Inserting Into Field Log..');
                  BEGIN
                     FORALL l_Index IN  1..l_count
                     INSERT INTO STTBS_FIELD_LOG
                     VALUES l_Tb_Field_Log(l_index);
                  EXCEPTION
                     WHEN OTHERS THEN
                        Dbg('Failed in Insert into Field Log..');
                        Dbg(SQLERRM);
                        p_Err_Code    := 'ST-UPLD-001';
                        p_Err_Params  := '@STTBS_FIELD_LOG';
                  END;
               END IF;

            END IF;
            g_curr_stage := 'POSTMAINTLOG';
            l_Skip_custom:= g_Skip_custom;
            stpks_stdbor22_Main.Pr_Set_Skip_CUSTOM;
            l_Wrk_stdbor22:=p_Wrk_stdbor22;
            Pr_Skip_Handler('POSTMAINTLOG');
            Dbg('Calling Post Upload Hooks For any Additional Logging');
            IF NOT stpks_stdbor22_Main.Fn_Skip_custom  THEN
               IF NOT stpks_stdbor22_Custom.Fn_Post_Upload_Db (p_Source,
                  p_Source_operation,
                  p_Function_id,
                  p_Action_Code,
                  p_function_Id  ,
                  g_Post_Upl_Stat,
                  p_Multi_Trip_Id,
                  p_stdbor22,
                  p_Prev_stdbor22,
                  l_Wrk_stdbor22,
                  p_Err_Code,
                  p_Err_Params) THEN
                  Dbg('Failed in stpks_stdbor22_Custom.Fn_Post_Upload_Db After Logging');
                  RETURN FALSE;
               END IF;
            END IF;
            g_Skip_custom:= l_Skip_custom;
            g_curr_stage := NULL;
         END IF;
      END IF;

      Dbg('Returning Success From Fn_Maint_Log..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Maint_Log ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Maint_Log;

   FUNCTION Fn_Extract_Custom_Data (p_Source   IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_Addl_Info         IN OUT Cspks_Req_Global.Ty_Addl_Info,
                              p_Status            IN OUT VARCHAR2 ,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      E_Failure_Exception     EXCEPTION;
      l_stdbor22     stpks_stdbor22_Main.Ty_stdbor22;

   BEGIN

      Dbg('In Fn_Extract_Custom_Data.. ');
      IF NOT  Fn_Build_Type(p_source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         p_Addl_Info,
         l_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Build_Type..');
         p_Status      := 'F';
         RAISE e_Failure_Exception;
      END IF;
      Dbg('Calling  Fn_Get_Key_Information..');
      IF NOT  Fn_Get_Key_Information(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         l_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Get_Key_Information..');
         RAISE e_Failure_Exception;
      END IF;
      p_Addl_Info := l_stdbor22.Addl_Info;
      Dbg('Returning from Fn_Extract_Custom_Data..');
      RETURN TRUE;

   EXCEPTION
      WHEN E_Failure_Exception THEN
         Dbg('From E_Failure_Exception of Fn_Extract_Custom_Data..');
         p_Status        := 'F';
         Dbg('Errors     :'||p_Err_Code);
         Dbg('Parameters :'||p_Err_Params);
         RETURN TRUE;
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Extract_Custom_Data..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Status      := 'F';
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Extract_Custom_Data;

   FUNCTION Fn_Rebuild_Ts_List (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_Exchange_Pattern  IN     VARCHAR2,
                              p_Status            IN OUT VARCHAR2 ,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      E_Failure_Exception     EXCEPTION;

   BEGIN

      Dbg('In Fn_Rebuild_Ts_List ');
      IF NOT  Fn_Build_Ts_List(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         p_Exchange_Pattern,
         g_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Build_Ts_List');
         p_Status      := 'F';
         RETURN FALSE;
      END IF;
      Dbg('Returning Success From Fn_Rebuild_Ts_List..');
      RETURN TRUE;

   EXCEPTION
      WHEN E_Failure_Exception THEN
         Dbg('From E_Failure_Exception of Fn_Rebuild_Ts_List');
         p_Status        := 'F';
         Dbg('Errors     :'||p_Err_Code);
         Dbg('Parameters :'||p_Err_Params);
         RETURN TRUE;
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Rebuild_Ts_List..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Status      := 'F';
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Rebuild_Ts_List;

   FUNCTION Fn_Get_Node_Data (
      p_Node_Data         IN OUT Cspks_Req_Global.Ty_Tb_Chr_Node_Data,
      p_Err_Code          IN OUT VARCHAR2,
      p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN   IS
      l_Cntr NUMBER := 0;
   BEGIN

      Dbg('In Fn_Get_Node_Data..');
      l_Cntr  := Nvl(p_Node_Data.Count,0) + 1;
      p_Node_Data(l_Cntr).Node_Name := 'BLK_MAIN';
      p_Node_Data(l_Cntr).Xsd_Node := 'Main';
      p_Node_Data(l_Cntr).Node_Parent := '';
      p_Node_Data(l_Cntr).Node_Relation_Type := '1';
      p_Node_Data(l_Cntr).Query_Node := '0';
      p_Node_Data(l_Cntr).Node_Fields := 'CAT~DESCRIPT~PRODUCT_RESTRICTION~RELATIONSHIP~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH~';
      p_Node_Data(l_Cntr).Node_Tags := 'CAT~DESCRIPT~PRODUCT_RESTRICTION~RELATIONSHIP~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH~';

      l_Cntr  := Nvl(p_Node_Data.Count,0) + 1;
      p_Node_Data(l_Cntr).Node_Name := 'BLK_BOTTOM';
      p_Node_Data(l_Cntr).Xsd_Node := 'Bottom';
      p_Node_Data(l_Cntr).Node_Parent := 'BLK_MAIN';
      p_Node_Data(l_Cntr).Node_Relation_Type := 'N';
      p_Node_Data(l_Cntr).Query_Node := '0';
      p_Node_Data(l_Cntr).Node_Fields := 'CAT~PRODUCT_CODE~RELATIONSHIP~';
      p_Node_Data(l_Cntr).Node_Tags := 'CAT~PRODUCT_CODE~RELATIONSHIP~';

      Dbg('Returning From Fn_Get_Node_Data.. ');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others Of stpks_stdbor22_Main.Fn_Get_Node_Data..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := NULL;
         RETURN FALSE;
   END Fn_Get_Node_Data;
   FUNCTION Fn_Int_Main   (p_Source            IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_action_Code       IN     VARCHAR2,
                              p_Multi_Trip_Id     IN     VARCHAR2,
                              p_Request_No        IN     VARCHAR2,
                              p_stdbor22          IN OUT stpks_stdbor22_Main.ty_stdbor22,
                              p_Status            IN OUT VARCHAR2 ,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      E_Failure_Exception     EXCEPTION;
      E_Override_Exception    EXCEPTION;
      l_Resultant_Error_Type  VARCHAR2(32767):= 'I';
      l_Post_Upl_Stat         VARCHAR2(1) :='A';
      l_Prev_Auth_Stat        VARCHAR2(1) :='U';
      l_Wrk_stdbor22    stpks_stdbor22_Main.Ty_stdbor22;
      l_Prev_stdbor22    stpks_stdbor22_Main.Ty_stdbor22;
      l_Dmy_stdbor22    stpks_stdbor22_Main.Ty_stdbor22;
      l_Pk_Or_Full    VARCHAR2(5) :='PK';
      l_Full_Data    VARCHAR2(1) := 'Y';
      l_With_Lock    VARCHAR2(1) := 'N';
      l_Qrydata_Reqd    VARCHAR2(1) := 'Y';
      l_Count         NUMBER;
      l_Action_Code       VARCHAR2(100):= p_Action_Code;
      l_Record_Master     Sttbs_Record_Master%ROWTYPE;
      l_Sent_Mod_No                NUMBER;
      l_Tanking_Status                VARCHAR2(1) := 'N';

   BEGIN

      Dbg('In Fn_Int_Main..');

      SAVEPOINT Sp_Int_Main_Stdbor22;
      p_Status := 'S';
      g_Tanking_Status := l_Tanking_Status;
      g_stdbor22 := p_stdbor22;
      l_Wrk_stdbor22 := p_stdbor22;

      Dbg('Calling  Fn_Check_Mandatory..');
      IF NOT Fn_Check_Mandatory(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         l_Pk_Or_Full,
         p_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Check_Mandatory..');
         Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
         RAISE E_Failure_Exception;
      END IF;

      IF NOT  Fn_Get_Key_Information(p_Source,
         p_Source_Operation,
         p_Function_id,
         p_Action_Code,
         p_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Get_Key_Information..');
         RAISE e_Failure_Exception;
      END IF;
      l_Sent_Mod_No := p_stdbor22.v_sttm_bor22_master.Mod_No;
      Dbg('Calling Cspks_Req_Utils.Fn_Process_Tanked_Entries..');
      IF NOT Cspks_Req_Utils.Fn_Process_Tanked_Entries(p_Source,
         p_Source_Operation,
         p_Function_Id,
         p_Action_Code,
         g_Key_Id,
         l_Sent_Mod_No,
         l_Action_Code,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in  Cspks_Req_Utils.Fn_Process_Tanked_Entries..');
         RAISE E_Failure_Exception;
      END IF;

      IF p_Action_Code = Cspks_Req_Global.p_query THEN
         Dbg('Calling in Fn_Query..');
         IF NOT Fn_Query(p_Source,
            p_Source_Operation,
            p_Function_Id,
            l_Action_Code,
            l_Full_data,
            l_with_lock,
            l_Qrydata_Reqd,
            p_stdbor22,
            l_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in Fn_Query..');
            Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
            RAISE E_Failure_Exception;
         END IF;
      ELSE
         Dbg('Calling  Fn_Default_And_Validate..');
         IF NOT Fn_Default_And_Validate (p_Source,
            p_Source_Operation,
            p_Function_Id,
            l_Action_Code,
            p_stdbor22,
            l_Prev_stdbor22,
            l_Wrk_stdbor22,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in Fn_Default_And_Validate..');
            pr_log_error(p_Source,p_Err_Code, p_Err_Params);
            RAISE E_Failure_Exception;
         END IF;

         -- Get Resultant Error Type
         l_Resultant_Error_Type := Cspks_Req_Utils.Fn_Get_Resultant_Error_Type;
         IF l_Resultant_Error_Type <> 'E' THEN
            Dbg('Calling  Fn_Upload_Db..');
            IF NOT Fn_Upload_Db (p_Source,
               p_Source_Operation,
               p_Function_Id,
               l_Action_Code,
               l_Post_Upl_Stat,
               p_Multi_Trip_Id,
               p_stdbor22,
               l_Prev_stdbor22,
               l_Wrk_stdbor22,
               p_Err_Code,
               p_Err_Params) THEN
               Dbg('Failed in Fn_Upload_Db..');
               pr_log_error(p_Source,p_Err_Code, p_Err_Params);
               RAISE E_Failure_Exception;
            END IF;
            IF  l_Action_Code IN (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen) THEN
               l_Prev_Auth_Stat := NVL(l_Prev_stdbor22.v_sttm_bor22_master.Auth_Stat,'A') ;
               --Get Upload Status
               Dbg('Calling Cspks_Req_Utils.Fn_Get_Auto_Auth_Status..');
               IF NOT Cspks_Req_Utils.Fn_Get_Auto_Auth_Status (p_Source,
                  p_Source_Operation,
                  p_Function_Id,
                  l_Action_Code,
                  l_Prev_Auth_Stat,
                  p_Multi_Trip_Id,
                  P_Request_No,
                  l_Post_Upl_Stat,
                  p_Err_Code,
                  p_Err_Params) THEN
                  Dbg('Failed in Cspks_Req_Utils.Fn_Get_Auto_Auth_Status..');
                  Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
                  RAISE E_Failure_Exception;
               END IF;

               IF l_Post_Upl_Stat NOT IN ('A','U','O') THEN
                  Dbg('Cannot Proceed Further..');
                  RAISE E_Failure_Exception;
               ELSE
                  IF l_post_upl_stat = 'A'THEN
                     Dbg('Calling  Fn_Upload_Db..');
                     IF NOT Fn_Upload_Db (p_Source,
                        p_Source_Operation,
                        p_Function_Id,
                        Cspks_Req_Global.p_auth,
                        l_Post_Upl_Stat,
                        p_Multi_Trip_Id,
                        p_stdbor22,
                        l_Prev_stdbor22,
                        l_Wrk_stdbor22,
                        p_Err_Code,
                        p_Err_Params) THEN
                        Dbg('Failed in Fn_Upload_Db..');
                        Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
                        RAISE E_Failure_Exception;
                     END IF;
                  END IF;
               END IF;
            END IF;
            --Get Upload Status
            Dbg('Calling  Cspks_Req_Utils.Fn_Get_Upload_Status..');
            IF NOT Cspks_Req_Utils.Fn_Get_Upload_Status (p_Source,
               p_source_operation,
               p_Function_Id,
               l_Action_Code,
               p_Multi_Trip_Id,
               P_Request_No,
               l_Post_Upl_Stat,
               p_Err_Code,
               p_Err_Params) THEN
               Dbg('Failed in Cspks_Req_Utils.Fn_Get_Upload_Status..');
               Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
               RAISE E_Failure_Exception;
            END IF;

            IF l_Post_Upl_Stat IN ('A','U') THEN
               Dbg('Success Case...');
               IF l_Action_Code IN (Cspks_Req_Global.p_New,Cspks_Req_Global.p_Modify,Cspks_Req_Global.p_Auth,Cspks_Req_Global.p_Close,Cspks_Req_Global.p_Reopen,Cspks_Req_Global.p_Query,Cspks_Req_Global.p_Version_Delete ) THEN
                  IF NOT Fn_Query(p_Source,
                     p_Source_Operation,
                     p_Function_Id,
                     l_Action_Code,
                     l_Full_Data,
                     l_With_Lock,
                     l_Qrydata_Reqd,
                     l_Wrk_stdbor22,
                     l_Wrk_stdbor22,
                     p_Err_Code,
                     p_Err_Params) THEN
                     Dbg('Failed in Fn_Query..');
                     Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
                     RAISE E_Failure_Exception;
                  END IF;
               END IF;
            ELSIF l_Post_Upl_Stat ='O' THEN
               Dbg('Raising Override Exception..');
               RAISE E_Override_Exception;
            ELSE
               Dbg('Not Feasible to Proceed..');
               RAISE E_Failure_Exception;
            END IF;
         ELSE
            Dbg('Encountered Errros..');
            RAISE E_Failure_Exception;
         END IF;
         Dbg('Calling Fn_Populate_Record_Master..');
         IF NOT Fn_Populate_Record_Master(p_Source,
            p_Source_Operation,
            p_Function_Id,
            l_Action_Code,
            l_Wrk_stdbor22,
            l_Record_Master,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Failed in Fn_Populate_Record_Master..');
            Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
            RAISE E_Failure_Exception;
         END IF;
         IF NOT Fn_Tank_Modification(p_Source,
            p_Source_Operation,
            p_Function_Id,
            l_Action_Code,
            l_Tanking_Status,
            p_Err_Code,
            p_Err_Params) THEN
            Dbg('Rolling Back the Modification..');
            Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
            RAISE E_Failure_Exception;
         END IF;

      END IF; -- Action Code

      Cspks_Req_Utils.Pr_Get_Final_Err_Code(p_Function_Id,l_Action_Code,l_Post_Upl_Stat,p_Err_Code,p_Err_Params);
      Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
      g_stdbor22 := l_wrk_stdbor22;
      g_post_upl_stat := l_Post_Upl_Stat;
      Dbg('Calling  Cspks_Req_Utils.Fn_Maint_Log..');
      IF NOT Fn_Maint_Log(p_Source,
         p_Source_Operation,
         p_Function_Id,
         l_Action_Code,
         p_Multi_Trip_Id,
         p_Request_No,
         l_Record_Master,
         p_stdbor22,
         l_Prev_stdbor22,
         l_Wrk_stdbor22,
         l_Tanking_Status,
         p_Err_Code,
         p_Err_Params) THEN
         Dbg('Failed in   Cspks_Req_Utils.Fn_Maint_Log..');
         Pr_Log_Error(p_Source,p_Err_Code, p_Err_Params);
         RAISE E_Failure_Exception;
      END IF;
      IF l_Action_Code = Cspks_Req_Global.p_Delete AND p_Source = 'FLEXCUBE'  THEN
         l_Wrk_stdbor22 := l_Dmy_stdbor22;
      END IF;
      p_stdbor22 := l_wrk_stdbor22;
      Dbg('Errors     :'||p_Err_Code);
      Dbg('Parameters :'||p_Err_Params);

      Dbg('Returning Success From Fn_Int_Main..');
      RETURN TRUE;

   EXCEPTION
      WHEN E_Failure_Exception THEN
         Dbg('From E_Failure_Exception of Fn_Int_Main..');
         ROLLBACK TO Sp_Int_Main_Stdbor22;
         p_Status        := 'F';
         l_Post_Upl_Stat := 'F';
         Cspks_Req_Utils.Pr_Get_Final_Err_Code(p_Function_Id,l_Action_Code,l_Post_Upl_Stat,p_Err_Code,p_Err_Params);
         Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
         Dbg('Errors     :'||p_Err_Code);
         Dbg('Parameters :'||p_Err_Params);
         RETURN TRUE;

      WHEN E_Override_Exception THEN
         Dbg('From E_Override_Exception of Fn_Int_Main');
         p_Status        := 'O';
         l_post_upl_stat := 'O';
         IF NOT Cspks_Req_Utils.Fn_Log_Overrides(p_Multi_Trip_Id, p_Request_No, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed inCspks_Req_Utils.Fn_Log_Overrides..');
            p_Err_Code    := 'ST-OTHR-001';
            p_Err_Params  := Null;
            RETURN FALSE;
         END IF;
         Cspks_Req_Utils.Pr_Get_Final_Err_Code(p_Function_Id,l_Action_Code,l_Post_Upl_Stat,p_Err_Code,p_Err_Params);
         Pr_Log_Error(p_Source,p_Err_Code,p_Err_Params);
         Dbg('Errors     :'||p_Err_Code);
         Dbg('Parameters :'||p_Err_Params);
         RETURN TRUE;

      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Int_Main ..');
         Debug.Pr_Debug('**',SQLERRM);
         ROLLBACK TO Sp_Int_Main_Stdbor22;
         p_Status      := 'F';
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Int_Main;

   FUNCTION Fn_Main   (p_Source            IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_Multi_Trip_Id     IN     VARCHAR2,
                              p_Request_No        IN     VARCHAR2,
                              p_stdbor22          IN OUT stpks_stdbor22_Main.ty_stdbor22,
                              p_Status            IN OUT VARCHAR2 ,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      E_Failure_Exception     EXCEPTION;
      E_Override_Exception    EXCEPTION;

   BEGIN

      Dbg('In Fn_Main..');
      SAVEPOINT Sp_Main_Stdbor22;
      Dbg('Calling  Fn_Int_Main..');
      IF NOT  Fn_Int_Main(p_Source,
         p_Source_Operation,
         p_Function_id,
         p_Action_Code,
         p_Multi_Trip_Id,
         p_Request_No,
         p_stdbor22,
         p_Status,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Int_Main..');
         RAISE E_Failure_Exception;
      END IF;
      IF p_Status = 'F' THEN
         RAISE E_Failure_Exception;
      ELSIF p_Status = 'O' THEN
         RAISE E_Override_Exception;
      END IF;
      Dbg('Returning Success From Fn_Main..');
      RETURN TRUE;

   EXCEPTION
      WHEN E_Failure_Exception THEN
         Dbg('From E_Failure_Exception of Fn_Main');
         ROLLBACK TO Sp_Main_Stdbor22;
         p_Status      := 'F';
         RETURN TRUE;

      WHEN E_Override_Exception THEN
         Dbg('From E_Override_Exception of Fn_Main..');
         p_Status      := 'O';
         RETURN TRUE;

      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Main ..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Status      := 'F';
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         ROLLBACK TO Sp_Main_Stdbor22;
         RETURN FALSE;
   END Fn_Main;

   FUNCTION Fn_Process_Request (p_Source    IN     VARCHAR2,
                              p_Source_Operation  IN     VARCHAR2,
                              p_Function_Id       IN     VARCHAR2,
                              p_Action_Code       IN     VARCHAR2,
                              p_Exchange_Pattern  IN     VARCHAR2,
                              p_Multi_Trip_Id     IN     VARCHAR2,
                              p_Request_No        IN     VARCHAR2,
                              p_Addl_Info         IN OUT Cspks_Req_Global.Ty_Addl_Info,
                              p_Status            IN OUT VARCHAR2 ,
                              p_Err_Code          IN OUT VARCHAR2,
                              p_Err_Params        IN OUT VARCHAR2)
   RETURN BOOLEAN IS

      l_stdbor22     stpks_stdbor22_Main.ty_stdbor22;

   BEGIN

      Dbg('In Fn_Process_Request ');
      IF NOT  Fn_Build_Type(p_Source,
         p_Source_Operation,
         p_Function_id,
         p_Action_Code,
         p_Addl_Info,
         l_stdbor22,
         p_Err_Code,
         p_Err_Params)  THEN
         Dbg('Failed in Fn_Build_Type..');
         p_status      := 'F';
         RETURN FALSE;
      END IF;
      IF Cspks_Req_Global.Fn_UnTanking THEN
         IF NOT  Fn_Int_Main(p_Source,
            p_Source_Operation,
            p_Function_Id,
            p_Action_Code,
            p_Multi_Trip_Id,
            p_Request_No,
            l_stdbor22,
            p_Status,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_main..');
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT  Fn_Main(p_source,
            p_Source_Operation,
            p_Function_id,
            p_Action_Code,
            p_Multi_Trip_Id,
            p_Request_No,
            l_stdbor22,
            p_Status,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_main..');
            RETURN FALSE;
         END IF;
      END IF;

      p_addl_info := l_stdbor22.Addl_Info;
      IF Cspks_Req_Global.Fn_Build_Resp THEN
         Cspks_Req_Global.Pr_Reset;
         IF NOT  Fn_Build_Ts_List(p_Source,
            p_Source_Operation,
            p_Function_id,
            p_Action_Code,
            p_Exchange_Pattern,
            l_stdbor22,
            p_Err_Code,
            p_Err_Params)  THEN
            Dbg('Failed in Fn_Build_Ts_List..');
            p_Status      := 'F';
            RETURN FALSE;
         END IF;
         Cspks_Req_Global.Pr_Close_Ts;
      END IF;
      Dbg('Returning Success From Fn_Process_Request..');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**','In When Others of Fn_Process_Request..');
         Debug.Pr_Debug('**',SQLERRM);
         p_Status      := 'F';
         p_Err_Code    := 'ST-OTHR-001';
         p_Err_Params  := Null;
         RETURN FALSE;
   END Fn_Process_Request;

END stpks_stdbor22_main;
/