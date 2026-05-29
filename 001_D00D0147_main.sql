USE LEMONSYS


Declare @XmlContent xml,@XAMLContent xml, @XmlContent01 xml,@XAMLContent01 xml

Set @XmlContent=N'
<form version="4.0.0" formID="D34F3230" type="Inquiry" caption="Thông tin chất lượng phiếu VCNB">
  <parameters>
    <parameter name="pFormIDPermission" dataType="text" value="D34F3230" />
  </parameters>
  <variables>
    <variable name="vPeriodFr" control="tdbcPeriodIDFr" dataType="text" binding="Period" />
    <variable name="vPeriodTo" control="tdbcPeriodIDTo" dataType="text" binding="Period" />
    <variable name="vTranMonthFr" control="tdbcPeriodIDFr" dataType="number" binding="TranMonth" />
    <variable name="vTranMonthTo" control="tdbcPeriodIDTo" dataType="number" binding="TranMonth" />
    <variable name="vTranYearFr" control="tdbcPeriodIDFr" dataType="number" binding="TranYear" />
    <variable name="vTranYearTo" control="tdbcPeriodIDTo" dataType="number" binding="TranYear" />
    <variable name="vReportDateFromFilter" control="tdbcReportDateFromFilter" dataType="date" binding="" />
    <variable name="vReportDateToFilter" control="tdbcReportDateToFilter" dataType="date" binding="" />
    <variable name="vPeriodID" control="tdbcPeriod" dataType="text" binding="PeriodID" />
    <variable name="voptIsPeriod" control="optPeriod" dataType="number" binding="" />
    <variable name="voptIsDate" control="optReportDate" dataType="number" binding="" />
    <variable name="vRDVoucherNo" control="tdbcSTVoucherNo" dataType="text" binding="VoucherNo" />

	<variable name="vTransTypeID" control="tdbcTransTypeID" dataType="text" binding="TranTypeID" />
  </variables>
  <datasets>
	<dataset name="STVoucherNo" queryText="EXEC D34P3230 value[''pDivisionID''], value[''pUserID''], value[''pHostName''], value[''vTranMonthFr''], value[''vTranYearFr''], value[''vTranMonthTo''], value[''vTranYearTo''], value[''vReportDateFromFilter''], value[''vReportDateToFilter''], value[''voptIsPeriod''], value[''voptIsDate''], '''', ''STVoucherNo'', value[''vTransTypeID''] " />
    <dataset name="Periods" queryText="Select Distinct REPLACE(STR(TranMonth, 2), '' '', ''0'') + ''/'' + STR(TranYear, 4) AS Period, TranMonth, TranYear From D03T9999 WITH(NOLOCK) Order By TranYear DESC, TranMonth DESC" />
	<dataset name="TransTypeID"
         queryText="EXEC D05P0001 5, value[''pUserID''], value[''pHostName''], 0, 1, '''', '''', 0" />
    <dataset name="dsCreateCol" queryText="EXEC D34P3230 value[''pDivisionID''], value[''pUserID''], value[''pHostName''], value[''vTranMonthFr''],value[''vTranYearFr''],value[''vTranMonthTo''],value[''vTranYearTo''],value[''vReportDateFromFilter''],value[''vReportDateToFilter''],             value[''voptIsPeriod''], value[''voptIsDate''], value[''vRDVoucherNo''], ''AddCol'',value[''vTransTypeID''] " />
    <dataset name="dsGrid" queryText="EXEC D34P3230 value[''pDivisionID''], value[''pUserID''], value[''pHostName''], value[''vTranMonthFr''],value[''vTranYearFr''],value[''vTranMonthTo''],value[''vTranYearTo''],value[''vReportDateFromFilter''],value[''vReportDateToFilter''],             value[''voptIsPeriod''], value[''voptIsDate''], value[''vRDVoucherNo''], ''LoadGrid'',value[''vTransTypeID''] " />
  </datasets>
  <commands>
    <command name="cmdFilter">
      <add type="required" control="tdbcSTVoucherNo;tdbcTransTypeID" />
      <add type="addCol" control="tdbg" dataset="dsCreateCol" />
      <add type="load" control="tdbg" dataset="dsGrid" />
    </command>
    <command name="cmdPrint">
      <add type="print" reportTypeID="D34F2311" moduleID="34" sqlMain="EXEC D34P3230 value[''pDivisionID''], value[''pUserID''], value[''pHostName''], value[''vTranMonthFr''],value[''vTranYearFr''],value[''vTranMonthTo''],value[''vTranYearTo''],value[''vReportDateFromFilter''],value[''vReportDateToFilter''],             value[''voptIsPeriod''], value[''voptIsDate''], value[''vRDVoucherNo''], ''Print'',value[''vTransTypeID''] " />
    </command>
  </commands>
  <form-items>
    <control name="tdbcSTVoucherNo" type="combo" dataset="STVoucherNo" dataDependent="tdbcPeriodIDFr;tdbcPeriodIDTo;tdbcTransTypeID" required="true" />
    <control name="tdbcPeriodIDFr" type="combo" dataset="Periods" event="SelectedIndexChanged" />
    <control name="tdbcPeriodIDTo" type="combo" dataset="Periods" event="SelectedIndexChanged" />
	<control name="tdbcTransTypeID" type="combo" dataset="TransTypeID" event="SelectedIndexChanged" required="true" />
    <control name="btnFilter" type="button" event="Click" command="cmdFilter" hotKey="F5" isAutoClick="true" />
    <control name="mnuPrint" event="Click" command="cmdPrint" />
  </form-items>
</form>
'

Set @XAMLContent=N'
<UserControl xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:dxg="http://schemas.devexpress.com/winfx/2008/xaml/grid" xmlns:dxc="http://schemas.devexpress.com/winfx/2008/xaml/core" xmlns:dxe="http://schemas.devexpress.com/winfx/2008/xaml/editors" xmlns:dxcn="http://schemas.devexpress.com/winfx/2008/xaml/core/internal" xmlns:dxgt="http://schemas.devexpress.com/winfx/2008/xaml/grid/themekeys" xmlns:L3="clr-namespace:Lemon3.Controls.DevExp;assembly=D99D0451" Width="Auto" Height="Auto">
  <UserControl.Resources>
    <ResourceDictionary>
      <dxcn:BrushSet x:Key="{dxgt:GridRowThemeKey ResourceKey=CellBackgroundBrushes}">
        <dxcn:BrushSet.Elements>
          <dxcn:BrushInfo x:Key="Focused" Brush="{StaticResource {dxgt:GridRowThemeKey ResourceKey=CellBorderFocusedBrush}}" />
          <dxcn:BrushInfo x:Key="Selected" Brush="{StaticResource {dxgt:GridRowThemeKey ResourceKey=BorderSelectedBrush}}" />
          <dxcn:BrushInfo x:Key="FocusedAndSelected" Brush="{StaticResource {dxgt:GridRowThemeKey ResourceKey=BorderFocusedBrush}}" />
          <dxcn:BrushInfo x:Key="BorderBrush" Brush="{StaticResource {dxgt:GridRowThemeKey ResourceKey=GridDataRowDelimiterBrush}}" />
          <dxcn:BrushInfo x:Key="BorderBrushFocusedRow" Brush="{StaticResource {dxgt:GridRowThemeKey ResourceKey=GridDataRowDelimiterBrush}}" />
        </dxcn:BrushSet.Elements>
      </dxcn:BrushSet>
      <!--Begin định dạng thuộc tính cho Header của cột-->
      <Style TargetType="dxg:GridColumnHeader">
        <Setter Property="dxg:BaseGridColumnHeader.ShowFilterButtonOnHover" Value="True" />
        <Setter Property="BorderThickness" Value="0" />
        <Setter Property="Background" Value="#F0F7FF" />
        <Setter Property="FontFamily" Value="Segoe UI" />
        <Setter Property="FontSize" Value="12" />
        <Setter Property="FontWeight" Value="Bold" />
      </Style>
      <!--End định dạng thuộc tính cho Header của cột-->
      <!--Begin định dạng thuộc tính cho thuộc tính của cột-->
      <Style TargetType="dxg:GridColumn">
        <Setter Property="HorizontalHeaderContentAlignment" Value="Center" />
        <Setter Property="AllowBestFit" Value="True" />
        <Setter Property="HeaderTemplate">
          <Setter.Value>
            <DataTemplate>
              <TextBlock Text="{Binding}" TextAlignment="Center" VerticalAlignment="Center" TextWrapping="Wrap" Foreground="{DynamicResource GridControlHeaderTextColour}" />
            </DataTemplate>
          </Setter.Value>
        </Setter>
      </Style>
      <!--End định dạng thuộc tính cho thuộc tính của cột-->
      <Style x:Key="SelectedRowStyle" TargetType="{x:Type dxg:RowControl}">
        <Setter Property="FontFamily" Value="Segoe UI" />
        <Setter Property="FontSize" Value="12" />
        <Style.Triggers>
          <DataTrigger Binding="{Binding Path=IsSelected}" Value="True">
            <Setter Property="Background" Value="#FFF0F5" />
            <Setter Property="Foreground" Value="Black" />
          </DataTrigger>
          <Trigger Property="dxg:GridViewBase.IsFocusedRow" Value="True">
            <Setter Property="Background" Value="#AEAD8E" />
            <Setter Property="Foreground" Value="Black" />
          </Trigger>
        </Style.Triggers>
      </Style>
      <!--Begin định dạng thuộc tính cho thuộc tính của cột Header Template in DataGrid Control (L3:L3GridControl) Áp dụng cho thuộc tính ColumnHeaderTemplate-->
      <!--<dxg:GridColumn.HeaderTemplate>				<DataTemplate>					<TextBlock Text="{Binding}" FontWeight="Bold"/>				</DataTemplate>			</dxg:GridColumn.HeaderTemplate>-->
      <Style TargetType="dxg:TableView">
        <Setter Property="ColumnHeaderTemplate">
          <Setter.Value>
            <DataTemplate>
              <ContentControl Content="{Binding}" Width="{Binding Width, RelativeSource={RelativeSource FindAncestor, AncestorType={x:Type DataGridColumnHeader}}}" Background="LightSkyBlue" TextBlock.FontWeight="Bold" TextBlock.FontFamily="Segoe UI" TextBlock.FontSize="12" TextBlock.TextAlignment="Center" VerticalContentAlignment="Top" HorizontalContentAlignment="Stretch" />
            </DataTemplate>
          </Setter.Value>
        </Setter>
      </Style>
      <!--End định dạng thuộc tính cho thuộc tính của cột Header Template in DataGrid Control (L3:L3GridControl) Áp dụng cho thuộc tính ColumnHeaderTemplate-->
    </ResourceDictionary>
  </UserControl.Resources>
  <Border BorderBrush="Black" BorderThickness="1">
    <Grid Name="GridMain">
      <Grid>
        <Grid.ColumnDefinitions>
          <ColumnDefinition />
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
          <RowDefinition Height="auto" />
          <RowDefinition Height="auto" />

        </Grid.RowDefinitions>
        <!--Begin Button Filter-->
        <L3:L3Button x:Name="btnFilter" Content="Lọc (F5)" HorizontalAlignment="Left" VerticalAlignment="Top" Height="22" Margin="849,16,-387,0" Width="76" RenderTransformOrigin="1.521,5.96" TabIndex="13" />
        <Label x:Name="lblPerio" Content="Kỳ" VerticalAlignment="Top" Margin="25,16,0,0" Height="26" RenderTransformOrigin="0.489,1.038" HorizontalAlignment="Left" Width="96" />
        <L3:L3LookUpEdit x:Name="tdbcPeriodIDTo" IsEnabled="{Binding ElementName=optPeriod, Path=IsChecked}" VerticalAlignment="Top" Margin="150,16,0,0" DisplayMember="Period" ValueMember="Period" AutoPopulateColumns="False" PopupWidth="50" ImmediatePopup="True" PopupContentTemplate="{DynamicResource PeriodIDStadard}" Height="22" TabIndex="5" HorizontalAlignment="Left" Width="91" />
        <L3:L3LookUpEdit x:Name="tdbcPeriodIDFr" IsEnabled="{Binding ElementName=optPeriod, Path=IsChecked}" VerticalAlignment="Top" Margin="56,16,0,0" DisplayMember="Period" ValueMember="Period" AutoPopulateColumns="False" PopupWidth="50" ImmediatePopup="True" PopupContentTemplate="{DynamicResource PeriodIDStadard}" Height="22" TabIndex="4" HorizontalAlignment="Left" Width="91" />
        <RadioButton x:Name="optPeriod" GroupName="Time" Content="Kỳ" Visibility="Hidden" Margin="12,16,0,0" VerticalAlignment="Top" IsChecked="True" Height="28" TabIndex="3" HorizontalAlignment="Left" Width="43" />
        <dxe:DateEdit x:Name="tdbcReportDateFromFilter" Visibility="Hidden" IsEnabled="{Binding ElementName=optReportDate, Path=IsChecked}" VerticalAlignment="Top" Margin="66,51,0,0" Mask="dd/MM/yyyy" MaskType="DateTime" DisplayFormatString="dd/MM/yyyy" NullValue="01/01/1900" DateTime="{Binding To, Mode=TwoWay, RelativeSource={RelativeSource AncestorType={x:Type Window}}, UpdateSourceTrigger=PropertyChanged}" Height="22" TabIndex="7" HorizontalAlignment="Left" Width="91" />
        <dxe:DateEdit x:Name="tdbcReportDateToFilter" Visibility="Hidden" IsEnabled="{Binding ElementName=optReportDate, Path=IsChecked}" VerticalAlignment="Top" Margin="160,51,0,0" Mask="dd/MM/yyyy" MaskType="DateTime" DisplayFormatString="dd/MM/yyyy" NullValue="01/01/1900" DateTime="{Binding To, Mode=TwoWay, RelativeSource={RelativeSource AncestorType={x:Type Window}}, UpdateSourceTrigger=PropertyChanged}" Height="22" TabIndex="8" HorizontalAlignment="Left" Width="91" />
        <RadioButton x:Name="optReportDate" Visibility="Hidden" GroupName="Time" Content="Ngày" Margin="12,52,0,0" VerticalAlignment="Top" Height="27" TabIndex="6" HorizontalAlignment="Left" Width="47" />
		
		<!--Begin Combo Loại nghiệp vụ-->
		<L3:L3LookUpEdit x:Name="tdbcTransTypeID"
						 HorizontalAlignment="Left"
						 Margin="120,48,0,0"
						 VerticalAlignment="Top"
						 Width="130"
						 Height="22"
						 DisplayMember="TranTypeID"
						 ValueMember="TranTypeID"
						 PopupWidth="500"
						 ImmediatePopup="True"
						 AutoPopulateColumns="False">

		  <L3:L3LookUpEdit.StyleSettings>
			<dxg:MultiSelectLookUpEditStyleSettings
				HighlightedTextBackground="#F5F5DC"
				HighlightedTextForeground="Black" />
		  </L3:L3LookUpEdit.StyleSettings>

		  <L3:L3LookUpEdit.PopupContentTemplate>
			<ControlTemplate>
			  <L3:L3GridControl x:Name="PART_GridControl">
				<L3:L3GridControl.Columns>
				  <dxg:GridColumn FieldName="TranTypeID"
								  Header="Mã"
								  Width="120"
								  HorizontalHeaderContentAlignment="Center"
								  AutoFilterCondition="Contains" />

				  <dxg:GridColumn FieldName="Description"
								  Header="Diễn giải"
								  Width="300"
								  HorizontalHeaderContentAlignment="Center"
								  AutoFilterCondition="Contains" />
				</L3:L3GridControl.Columns>

				<L3:L3GridControl.View>
				  <dxg:TableView HorizontalScrollbarVisibility="Auto"
								 VerticalScrollbarVisibility="Auto"
								 ShowCheckBoxSelectorColumn="True"
								 ShowAutoFilterRow="True"
								 ShowFilterPanelMode="Never"
								 AllowFilterEditor="True"
								 AllowPerPixelScrolling="True"
								 ShowTotalSummary="True"
								 ShowGroupPanel="False"
								 AutoWidth="True"
								 AllowBestFit="True"
								 BestFitArea="All"
								 BestFitMode="AllRows"
								 RowStyle="{StaticResource SelectedRowStyle}" />
				</L3:L3GridControl.View>
			  </L3:L3GridControl>
			</ControlTemplate>
		  </L3:L3LookUpEdit.PopupContentTemplate>
		</L3:L3LookUpEdit>
		<Label x:Name="lblTransTypeID" Content="Loại nghiệp vụ" HorizontalAlignment="Left" Margin="25,48,0,0" VerticalAlignment="Top" Height="26" Width="96" />

        <Label x:Name="lblVoucherNo" Content="Phiếu VCNB" VerticalAlignment="Top" Margin="284,18,0,0" Height="26" RenderTransformOrigin="0.489,1.038" HorizontalAlignment="Left" Width="96" />
        <L3:L3LookUpEdit x:Name="tdbcSTVoucherNo" PopupWidth="510" Margin="374,16,-278,0" VerticalAlignment="Top" TabIndex="11" DisplayMember="VoucherNo" ValueMember="VoucherNo" ImmediatePopup="True" AutoPopulateColumns="False" Height="22" HorizontalAlignment="Left" Width="442">
          <L3:L3LookUpEdit.StyleSettings>
            <dxg:MultiSelectLookUpEditStyleSettings HighlightedTextBackground="#F5F5DC" HighlightedTextForeground="Black" />
          </L3:L3LookUpEdit.StyleSettings>
          <L3:L3LookUpEdit.PopupContentTemplate>
            <ControlTemplate>
              <L3:L3GridControl x:Name="PART_GridControl">
                <L3:L3GridControl.Columns>
                  <dxg:GridColumn FieldName="VoucherNo" Header="Số phiếu" Width="200" HorizontalHeaderContentAlignment="Center" AutoFilterCondition="Contains" />
                  <dxg:GridColumn FieldName="VoucherDesc" Header="Diễn giải" Width="200" HorizontalHeaderContentAlignment="Center" AutoFilterCondition="Contains" />
                  <dxg:GridColumn FieldName="VoucherDate" Header="Ngày" Width="110" HorizontalHeaderContentAlignment="Center" AutoFilterCondition="Contains" />
                </L3:L3GridControl.Columns>
                <L3:L3GridControl.View>
                  <dxg:TableView HorizontalScrollbarVisibility="Auto" ShowCheckBoxSelectorColumn="True" VerticalScrollbarVisibility="Auto" AllowPerPixelScrolling="True" ShowAutoFilterRow="True" ShowFilterPanelMode="Never" ShowTotalSummary="True" ShowGroupPanel="False" AutoWidth="True" AllowBestFit="True" BestFitArea="All" BestFitMode="AllRows" RowStyle="{StaticResource SelectedRowStyle}" />
                </L3:L3GridControl.View>
              </L3:L3GridControl>
            </ControlTemplate>
          </L3:L3LookUpEdit.PopupContentTemplate>
        </L3:L3LookUpEdit>
        <!--Begin Button Filter-->
      </Grid>
      <L3:L3GridControl x:Name="tdbg" EnableSmartColumnsGeneration="True" HorizontalAlignment="Stretch" HorizontalContentAlignment="Stretch" Width="Auto" Height="Auto" Margin="0,85,0,-0.2" Grid.RowSpan="2">
        <L3:L3GridControl.ContextMenu>
          <ContextMenu>
            <MenuItem Name="mnsListAll" Header="Liệt kê tất cả" />
            <MenuItem Name="mnuExportToExcel" Header="Xuất Excel theo mẫu" />
            <MenuItem Name="mnuExportExcelDirect" Header="Xuất Excel trực tiếp" />
            <MenuItem Name="mnuPrint" Header="In" />
          </ContextMenu>
        </L3:L3GridControl.ContextMenu>
        <dxg:GridControl.View>
          <dxg:TableView HorizontalScrollbarVisibility="Auto" VerticalScrollbarVisibility="Auto" AllowFilterEditor="True" ShowFilterPanelMode="Never" UseEvenRowBackground="True" EvenRowBackground="Beige" BestFitMode="AllRows" AllowBestFit="True" BestFitArea="All" AllowPerPixelScrolling="True" ShowTotalSummary="True" ShowAutoFilterRow="True" FilterRowDelay="2000" AllowEditing="True" ShowGroupedColumns="True" AllowGroupSummaryCascadeUpdate="True" RowStyle="{StaticResource SelectedRowStyle}">
            <dxg:TableView.FormatConditions>
              <dxg:FormatCondition Expression="[Style] = ''(B, Red)''">
                <dxc:Format FontWeight="Bold" Foreground="Red" />
              </dxg:FormatCondition>
              <dxg:FormatCondition Expression="[Style] = ''(B, Black)''">
                <dxc:Format FontWeight="Bold" Foreground="Black" />
              </dxg:FormatCondition>
              <dxg:FormatCondition Expression="[Style] = ''(I, Blue)''">
                <dxc:Format FontStyle="Italic" Foreground="Blue" />
              </dxg:FormatCondition>
              <dxg:FormatCondition Expression="[Style] = ''(I, Black)''">
                <dxc:Format FontStyle="Italic" Foreground="Black" />
              </dxg:FormatCondition>
              <dxg:FormatCondition Expression="[Style] = ''(Red)''">
                <dxc:Format Foreground="Red" />
              </dxg:FormatCondition>
              <dxg:FormatCondition Expression="[Style] = ''(FontWeight:B, FontColor:Black, FontSize:12)''">
                <dxc:Format FontWeight="Bold" Foreground="Black" FontSize="12" />
              </dxg:FormatCondition>
            </dxg:TableView.FormatConditions>
          </dxg:TableView>
        </dxg:GridControl.View>
      </L3:L3GridControl>
    </Grid>
  </Border>
</UserControl>
'

SET @XmlContent01 = ''
SET @XAMLContent01 = ''

IF NOT EXISTS(SELECT TOP 1 1 FROM D00T0147 WITH(NOLOCK) WHERE MenuItemID = '3431201')
BEGIN 
	INSERT INTO D00T0147(ModuleID, MenuItemID, MenuGroupID, DisplayOrder, PerrmissionSreenID, FormID, ProgramName, ProgramType, Parameter, LCode, 
	Disabled, IsAnchor, IsBlance, SqlCheckForm, XAMLContent, XmlContent, XmlContent01, XAMLContent01)
	VALUES (N'34',N'3431201',N'I',400,N'D34F3230',N'D89F4000',N'D89D4951',N'DAF40',N'',N'',0,0,0,N'',@XAMLContent,@XmlContent,@XmlContent01,@XAMLContent01)
END
ELSE
BEGIN 
	UPDATE D00T0147
	SET ModuleID = N'34',MenuItemID = N'3431201',MenuGroupID = N'I',DisplayOrder = 410,PerrmissionSreenID = N'D34F3230',
	 FormID = N'D89F4000', ProgramName = N'D89D4951', ProgramType = N'DAF40', SqlCheckForm = N'', Disabled = 0,XmlContent = @XmlContent,
	  XAMLContent = @XAMLContent, XmlContent01 = @XmlContent01, XAMLContent01 = @XAMLContent01
	WHERE MenuItemID = '3431201'
END
select *from LEMONSYS..D00T0147 where PerrmissionSreenID = N'D34F3230'

select *from LEMONSYS..D00T0147 where MenuItemID=N'3431201'

