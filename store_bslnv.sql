  
-- D34P3230   
-- <Summary>  
---- Thong tin chat luong phieu VCNB  
-- <Param>  
----   
-- <Return>  
----   
-- <Reference>  
---- D34\Thong ke va phan tich\Thong tin chat luong phieu van chuyen noi bo  
-- <History>  
---- Create on 02/05/2024 by HOAILAM (276427)  
----   
---- Modified on 02/05/2024 by   
-- <Example>  
----   
ALTER PROCEDURE D34P3230  
(  
 @DivisionID   VARCHAR(50) = '',  
 @UserID    VARCHAR(50) = '',  
 @HostID    VARCHAR(100) = '',  
 @FromMonth   VARCHAR(2) = '0',  
 @FromYear   VARCHAR(10) = '0',  
 @ToMonth   VARCHAR(2) = '0',  
 @ToYear    VARCHAR(10) = '0',  
 @DateFromFilter  DATETIME = NULL,  
 @DateToFilter  DATETIME = NULL,  
 @IsPeriod   TINYINT = 1,  
 @IsDate    TINYINT = 0,  
 @RDVoucherNo  VARCHAR(1000) = '',  
 @Type    VARCHAR(50) = ''  ,
 @TransTypeID VARCHAR(1000)=''
)   
AS   
SET NOCOUNT ON  
  
DECLARE @sSQL00 VARCHAR(8000) = ''  
  
DECLARE @D07_QuantityDecimals INT = 0  
  
SELECT  @D07_QuantityDecimals = D07_QuantityDecimals  
FROM  D91T0025 WITH(NOLOCK)   
  
SELECT @D07_QuantityDecimals = ISNULL(@D07_QuantityDecimals, 0)  
  
  
SET @RDVoucherNo = REPLACE(@RDVoucherNo,'(','')  
SET @RDVoucherNo = REPLACE(@RDVoucherNo,')','')  
SET @RDVoucherNo = REPLACE(@RDVoucherNo,'''','')  
  
SELECT  DISTINCT   
   T0009.RDVoucherNo, T0009.RDVoucherID, T0011.InventoryID, T0011.LocationNo, T2020.VoucherID, T2020.CPlanID  
INTO  #TempInfo  
FROM  D07T0009 T0009 WITH(NOLOCK)  
INNER JOIN D07T0011 T0011 WITH(NOLOCK)  
 ON  T0011.RDVoucherID = T0009.RDVoucherID  
LEFT JOIN D34T2020 T2020 WITH(NOLOCK)  
 ON  T2020.LocationNo = T0011.LocationNo AND T0011.LocationNo <> ''  
WHERE  T0009.DivisionID = @DivisionID AND T0009.KindVoucherID = 3  
   AND CHARINDEX(';' + T0009.RDVoucherNo + ';', ';' + @RDVoucherNo + ';') <> 0  
  
SELECT  DISTINCT T1052.CElementID, T1052.CaptionU AS Caption, T1020.CEDataType, T1020.Decimals  
INTO  #ElememtID  
FROM  D34T1052 T1052 WITH(NOLOCK)  
LEFT JOIN D34T1020 T1020 WITH(NOLOCK)  
 ON  T1020.CElementID = T1052.CElementID  
INNER JOIN #TempInfo T  
 ON  T1052.CPlanID = T.CPlanID  
WHERE  T1052.CPlanID <> ''   

IF @Type = 'AddCol'  
BEGIN  
    CREATE TABLE #StructTable  
 (  
  Level   TINYINT,   
  ParentNodeID VARCHAR(50),  
  CaptionID  VARCHAR(50),  
  CaptionName  NVARCHAR(500),  
  FieldName  VARCHAR(50),  
  Length   INT,      
  DataType  VARCHAR(50),  
  ControlType  VARCHAR(50),  
  ControlFormat VARCHAR(50),  
  DataFormat  VARCHAR(50),  
  Expression  VARCHAR(1000),  
  DefaultValues VARCHAR(1000),  
  SumFooter  VARCHAR(50),  
  IsHide   TINYINT DEFAULT(0),  
  DatatypeServer VARCHAR(50),  
  StyleCaption VARCHAR(50) DEFAULT('')  
 )  
  
 INSERT INTO #StructTable(Level, ParentNodeID, CaptionID, CaptionName, FieldName, Length, DataType, ControlType, ControlFormat, DataFormat, Expression, DefaultValues, SumFooter, IsHide, DatatypeServer, StyleCaption)  
 VALUES (0, '', 'VoucherOrderNum',N'STT' + CHAR(13) + N'phiếu','VoucherOrderNum',60,'N','T','R;M','N0','','','0',0,'INT',''),  
   (0, '', 'RDVoucherNo',N'Số phiếu VCNB','RDVoucherNo',150,'','T','R;M','','','','0',0,'VARCHAR(50)',''),  
   (0, '', 'ObjectID',N'Mã đối tượng','ObjectID',110,'','T','R','','','','0',0,'VARCHAR(50)',''),  
   (0, '', 'RDVoucherDate',N'Ngày phiếu VCNB','RDVoucherDate',90,'D','D','R','','','','0',0,'DATETIME',''),  
   (0, '', 'OrderNum',N'STT','OrderNum',50,'N','T','R','N0','','','0',0,'INT',''),  
   (0, '', 'InventoryID',N'Mã hàng','InventoryID',110,'','T','R','','','','0',0,'VARCHAR(50)',''),  
   (0, '', 'LocationNo',N'Lô','LocationNo',150,'','T','R','','','','0',0,'VARCHAR(100)','')  
  
 INSERT INTO #StructTable(Level, ParentNodeID, CaptionID, CaptionName, FieldName, Length, DataType, ControlType, ControlFormat, DataFormat, Expression, DefaultValues, SumFooter, IsHide, DatatypeServer, StyleCaption)  
 SELECT 0,'','QualityInfo',N'Thông tin chất lượng','QualityInfo',100,'','','R','','','','0',0,'',''  
 UNION ALL  
 SELECT 1,'QualityInfo',CElementID, Caption, CElementID, 110, CASE WHEN CEDataType = 'N' THEN 'N' WHEN CEDataType = 'D' THEN 'D' WHEN CEDataType = 'S' THEN '' WHEN CEDataType = 'Y' THEN 'C' ELSE '' END,  
   CASE WHEN CEDataType IN ('N','Y') THEN '' WHEN CEDataType = 'D' THEN 'D' WHEN CEDataType = 'S' THEN 'T' ELSE '' END,  
   'R',  
   CASE WHEN CEDataType = 'N' THEN 'N' + LTRIM(RTRIM(STR(Decimals))) WHEN CEDataType = 'Y' THEN 'N0' ELSE '' END,  
   '','','0',0,  
   CASE WHEN CEDataType = 'N' THEN 'DECIMAL(28,8)' WHEN CEDataType = 'S' THEN 'VARCHAR(100)' WHEN CEDataType = 'D' THEN 'DATETIME' WHEN CEDataType = 'Y' THEN 'INT' ELSE '' END,  
   ''  
 FROM #ElememtID  
  
 INSERT INTO #StructTable(Level, ParentNodeID, CaptionID, CaptionName, FieldName, Length, DataType, ControlType, ControlFormat, DataFormat, Expression, DefaultValues, SumFooter, IsHide, DatatypeServer, StyleCaption)  
 SELECT 0,'', 'LotNumSubInfo', N'Thông tin phụ của lô dạng số', 'LotNumSubInfo', 200, 'N','T','R', '', '','','0',0,'DECIMAL(28,8)',''  
 UNION ALL  
 SELECT 1,'LotNumSubInfo', 'Lot' + FieldName, Caption84U, 'Lot' + FieldName, 100, 'N','T','R', 'N' + LTRIM(RTRIM(STR(DecimalNum))), '','','0',0,'DECIMAL(28,8)',''  
 FROM D07T0037 WITH(NOLOCK)  
 WHERE TableName = 'D07T1210' AND DefaultUse = 1 AND FieldName LIKE 'INDEX%'  
 UNION ALL  
 SELECT 0,'', 'LotStrSubInfo', N'Thông tin phụ của lô dạng chuỗi', 'LotStrSubInfo', 110, '','T','R', '', '','','0',0,'NVARCHAR(250)',''  
 UNION ALL  
 SELECT 1,'LotStrSubInfo', 'Lot' + FieldName, Caption84U, 'Lot' + FieldName, 100, '','T','R', '', '','','0',0,'NVARCHAR(250)',''  
 FROM D07T0037 WITH(NOLOCK)  
 WHERE TableName = 'D07T1210' AND DefaultUse = 1 AND FieldName LIKE 'Str%'  
 UNION ALL  
 SELECT 0,'', 'LotDatSubInfo', N'Thông tin phụ của lô dạng ngày', 'LotDatSubInfo', 110, 'D','D','R', '', '','','0',0,'DATETIME',''  
 UNION ALL  
 SELECT 1,'LotDatSubInfo', 'Lot' + FieldName, Caption84U, 'Lot' + FieldName, 100, 'D','D','R', '', '','','0',0,'DATETIME',''  
 FROM D07T0037 WITH(NOLOCK)  
 WHERE TableName = 'D07T1210' AND DefaultUse = 1 AND FieldName LIKE 'Dat%'  
  
 IF NOT EXISTS (SELECT TOP 1 1 FROM #StructTable WHERE Level = 1 AND ParentNodeID = 'LotNumSubInfo' AND IsHide = 0)  
 BEGIN  
     DELETE #StructTable WHERE Level = 0 AND FieldName = 'LotNumSubInfo'  
 END  
  
 IF NOT EXISTS (SELECT TOP 1 1 FROM #StructTable WHERE Level = 1 AND ParentNodeID = 'LotStrSubInfo' AND IsHide = 0)  
 BEGIN  
     DELETE #StructTable WHERE Level = 0 AND FieldName = 'LotStrSubInfo'  
 END  
  
 IF NOT EXISTS (SELECT TOP 1 1 FROM #StructTable WHERE Level = 1 AND ParentNodeID = 'LotDatSubInfo' AND IsHide = 0)  
 BEGIN  
     DELETE #StructTable WHERE Level = 0 AND FieldName = 'LotDatSubInfo'  
 END  
  
 INSERT INTO #StructTable(Level, ParentNodeID, CaptionID, CaptionName, FieldName, Length, DataType, ControlType, ControlFormat, DataFormat, Expression, DefaultValues, SumFooter, IsHide, DatatypeServer, StyleCaption)  
 VALUES (0, '', 'LotInfo',N'Thông tin lô','LotInfo',0,'N','T','R','N','','','0',0,'DECIMAL(28,8)',''),  
   (1, 'LotInfo', 'GrossQuantity',N'Số lượng Gross','GrossQuantity',130,'N','T','R','N' + LTRIM(RTRIM(STR(@D07_QuantityDecimals))),'','','0',0,'DECIMAL(28,8)',''),  
   (1, 'LotInfo', 'NetQuantity',N'Số lượng Net','NetQuantity',130,'N','T','R','N' + LTRIM(RTRIM(STR(@D07_QuantityDecimals))),'','','0',0,'DECIMAL(28,8)','')  
  
 SELECT   *   
 FROM   #StructTable WITH(NOLOCK)   
END  
  
IF @Type IN ('LoadGrid','Print')  
BEGIN  
 SET @sSQL00 = '  
    SELECT  CONVERT(INT,NULL) AS VoucherOrderNum, T0009.RDVoucherID,  
    T0009.RDVoucherNo, T0009.RDVoucherDate, T0009.ObjectID, T0011.OrderNum, T0011.InventoryID, T0011.LocationNo,  
    T1210.INDEX01 AS LotINDEX01, T1210.INDEX02 AS LotINDEX02, T1210.INDEX03 AS LotINDEX03, T1210.INDEX04 AS LotINDEX04, T1210.INDEX05 AS LotINDEX05,  
    T1210.Str01U AS LotStr01, T1210.Str02U AS LotStr02, T1210.Str03U AS LotStr03, T1210.Str04U AS LotStr04, T1210.Str05U AS LotStr05,  
    T1210.Dat01 AS LotDat01, T1210.Dat02 AS LotDat02, T1210.Dat03 AS LotDat03, T1210.Dat04 AS LotDat04, T1210.Dat05 AS LotDat05,  
    T1210.GrossQuantity, T1210.NetQuantity  
 '  
  
 SELECT  @sSQL00 = @sSQL00 + CASE WHEN CEDataType IN ('N','Y') THEN '  
    , CONVERT(DECIMAL(28,8),0) AS ' WHEN CEDataType = 'D' THEN '  
    , CONVERT(DATETIME,NULL) AS ' WHEN CEDataType = 'S' THEN'  
    , CONVERT(VARCHAR(500),'''') AS ' ELSE '' END + '[' + CElementID +']'  
 FROM  #ElememtID  
  
 SET @sSQL00 = @sSQL00 + '  
 INTO  #Data  
 FROM  D07T0011 T0011 WITH(NOLOCK)  
 INNER JOIN D07T0009 T0009 WITH(NOLOCK)  
  ON  T0009.RDVoucherID = T0011.RDVoucherID  
 LEFT JOIN D07T1210 T1210 WITH(NOLOCK)  
  ON  T1210.LocationNo = T0011.LocationNo AND (T1210.InventoryID = T0011.InventoryID OR T1210.LocationNo = '''')  
 WHERE  T0009.KindVoucherID = 3 AND EXISTS (SELECT TOP 1 1 FROM #TempInfo T WHERE T.RDVoucherID = T0011.RDVoucherID)  
 '  
  
  
 SELECT  @sSQL00 = @sSQL00 + '  
 UPDATE  T  
 SET   T.[' + CElementID + '] = ' + CASE WHEN CEDataType IN ('N','Y') THEN ' CASE WHEN ISNUMERIC(CONVERT(VARCHAR(500),T2020.CEValue)) = 1 THEN CONVERT(VARCHAR(500),T2020.CEValue) ELSE T.[' + CElementID + '] END ' ELSE ' CONVERT(VARCHAR(500),T2020.CEValue
) ' END + '   
 FROM  #Data T  
 INNER JOIN D34T2020 T2020 WITH(NOLOCK)  
  ON  T.InventoryID = T2020.InventoryID AND T.LocationNo = T2020.LocationNo  
 WHERE  T2020.CElementID = ''' + CElementID + '''  
 '  
 FROM  #ElememtID  
  
 SET @sSQL00 = @sSQL00 + '  
 UPDATE  T  
 SET   T.VoucherOrderNum = T1.VoucherOrderNum  
 FROM  #Data T  
 INNER JOIN (  
    SELECT  ROW_NUMBER() OVER(ORDER BY RDVoucherDate DESC, RDVoucherNo ASC) AS VoucherOrderNum, RDVoucherID  
    FROM  #Data  
    GROUP BY RDVoucherID, RDVoucherNo, RDVoucherDate) T1  
  ON  T.RDVoucherID = T1.RDVoucherID  
  
 SELECT * FROM #Data  
 ORDER BY VoucherOrderNum, OrderNum  
 '  
  
 --PRINT @sSQL00  
 EXEC (@sSQL00)  
END  
  
  
  
  
  
