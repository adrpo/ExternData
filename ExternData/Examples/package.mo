// CP: 65001
/* package.mo - Modelica Examples library for data I/O of CSV, INI, JSON, MATLAB MAT, TIR, Excel XLS/XLSX or XML files
 *
 * Copyright (C) 2015-2021, tbeu
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

within ExternData;
package Examples "Test examples"
  extends Modelica.Icons.ExamplesPackage;
  model CSVTest "CSV file read test"
    extends Modelica.Icons.Example;
    inner parameter ExternData.CSVFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.csv")) "CSV file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    final parameter Integer m = dataSource.getArrayRows2D() "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D(3, 2)) annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the table parameter from the CSV file <a href=\"modelica://ExternData/Resources/Examples/test.csv\">test.csv</a>. The table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.CSVFile.getRealArray2D\">ExternData.CSVFile.getRealArray2D</a>. The read parameter is assigned by a parameter binding to the appropriate model parameter.</p></html>"));
  end CSVTest;

  model INITest "INI file read test"
    extends Modelica.Icons.Example;
    parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    inner parameter ExternData.INIFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.ini")) "INI file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal("gain.k", setName)) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString("gain.k", setName))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain parameters from different sections of the INI file <a href=\"modelica://ExternData/Resources/Examples/test.ini\">test.ini</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.INIFile.getReal\">ExternData.INIFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.INIFile.getString\">ExternData.INIFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end INITest;

  model JSONTest "JSON file read test"
    extends Modelica.Icons.Example;
    parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    inner parameter ExternData.JSONFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.json")) "JSON file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal(setName + ".gain.k")) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString(setName + ".gain.k"))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("table1", 3, 2)) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain parameters from different nodes of the JSON file <a href=\"modelica://ExternData/Resources/Examples/test.json\">test.json</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.JSONFile.getReal\">ExternData.JSONFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.JSONFile.getString\">ExternData.JSONFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). For timeTable the table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.JSONFile.getRealArray2D\">ExternData.JSONFile.getRealArray2D</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end JSONTest;

  model MATTest "MAT-file read test"
    extends Modelica.Icons.Example;
    inner parameter ExternData.MATFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test_v7.3.mat")) "MAT file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("table1", 3, 2)) annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the table parameter from variable table1 of the HDF5-based MAT-file <a href=\"modelica://ExternData/Resources/Examples/test_v7.3.mat\">test_v7.3.mat</a>. The table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.MATFile.getRealArray2D\">ExternData.MATFile.getRealArray2D</a>. The read parameter is assigned by a parameter binding to the appropriate model parameter.</p></html>"));
  end MATTest;

  model SSVTest "SSV file read test"
    extends Modelica.Icons.Example;
    inner parameter ExternData.SSVFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.ssv")) "SSV file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal("gain.k")) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain parameter from the corresponding node of the SSV file <a href=\"modelica://ExternData/Resources/Examples/test.ssv\">test.ssv</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.SSVFile.getReal\">ExternData.SSVFile.getReal</a>. The read parameter is assigned by a parameter binding to the appropriate model parameter.</p></html>"));
  end SSVTest;

  model XLSTest "Excel XLS file read test"
    extends Modelica.Icons.Example;
    parameter String sheetName="set1" "Excel sheet name" annotation(choices(choice="set1" "First Excel sheet", choice="set2" "Second Excel sheet"));
    inner parameter ExternData.XLSFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xls")) "XLS file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal("B2", sheetName)) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString("B2", sheetName))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("A1", "table1", 3, 2)) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
    final parameter Real sumB = computeColSum(dataSource, "B") "Sum of column B";
    function computeColSum "Compute column sum"
      extends Modelica.Icons.Function;
      input ExternData.XLSFile dataSource "Excel XLS file record";
      input String col = "A" "Column";
      input String sheetName="" "Sheet name";
      input Integer startRow = 2 "Start row";
      input Integer endRow = ExternData.Functions.XLS.getArrayRows2D(sheetName=sheetName, xls=dataSource.xls) "End row";
      output Real colSum "Column sum";
      protected
        Real val;
        Boolean exist;
      algorithm
        colSum := 0.0;
        for row in startRow:endRow loop
          (val, exist) := ExternData.Functions.XLS.getReal(cellAddress=col + String(row), sheetName=sheetName, xls=dataSource.xls);
          if exist then
            colSum := colSum + val;
          end if;
        end for;
      annotation(Documentation(info="<html><p>This function computes the column sum of a given column and sheet of an Excel XLS file.</p></html>"));
    end computeColSum;
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain parameters from different cells and sheets of the Excel XLS file <a href=\"modelica://ExternData/Resources/Examples/test.xls\">test.xls</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XLSFile.getReal\">ExternData.XLSFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XLSFile.getString\">ExternData.XLSFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). For timeTable the table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.XLSFile.getRealArray2D\">ExternData.XLSFile.getRealArray2D</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XLSTest;

  model XLSXTest "Excel XLSX file read test"
    extends Modelica.Icons.Example;
    parameter String sheetName="set1" "Excel sheet name" annotation(choices(choice="set1" "First Excel sheet", choice="set2" "Second Excel sheet"));
    inner parameter ExternData.XLSXFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xlsx")) "XLSX file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal("B2", sheetName)) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString("B2", sheetName))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("A1", "table1", 3, 2)) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
    final parameter Real sumB = computeColSum(dataSource, "B") "Sum of column B";
    function computeColSum "Compute column sum"
      extends Modelica.Icons.Function;
      input ExternData.XLSXFile dataSource "Excel XLSX file record";
      input String col = "A" "Column";
      input String sheetName="" "Sheet name";
      input Integer startRow = 2 "Start row";
      input Integer endRow = ExternData.Functions.XLSX.getArrayRows2D(sheetName=sheetName, xlsx=dataSource.xlsx) "End row";
      output Real colSum "Column sum";
      protected
        Real val;
        Boolean exist;
      algorithm
        colSum := 0.0;
        for row in startRow:endRow loop
          (val, exist) := ExternData.Functions.XLSX.getReal(cellAddress=col + String(row), sheetName=sheetName, xlsx=dataSource.xlsx);
          if exist then
            colSum := colSum + val;
          end if;
        end for;
      annotation(Documentation(info="<html><p>This function computes the column sum of a given column and sheet of an Excel XLSX file.</p></html>"));
    end computeColSum;
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain parameters from different cells and sheets of the Excel XLSX file <a href=\"modelica://ExternData/Resources/Examples/test.xlsx\">test.xlsx</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XLSXFile.getReal\">ExternData.XLSXFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XLSXFile.getString\">ExternData.XLSXFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). For timeTable the table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.XLSXFile.getRealArray2D\">ExternData.XLSXFile.getRealArray2D</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XLSXTest;

  model XMLTest "XML file read test"
    extends Modelica.Icons.Example;
    parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    inner parameter ExternData.XMLFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xml")) "XML file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal(setName + ".gain.k")) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString(setName + ".gain.k"))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
    Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("table1", 3, 2)) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain and table parameters from different nodes of the XML file <a href=\"modelica://ExternData/Resources/Examples/test.xml\">test.xml</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XMLFile.getReal\">ExternData.XMLFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XMLFile.getString\">ExternData.XMLFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). For timeTable the table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.XMLFile.getRealArray2D\">ExternData.XMLFile.getRealArray2D</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XMLTest;

  model XMLTest2 "XML file read test using inner/outer hierarchy"
    extends Modelica.Icons.Example;
    inner parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    inner parameter ExternData.XMLFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xml")) "XML file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    model Component
      outer parameter String setName "Parameter set name";
      extends ExternData.Interfaces.DataSourceModel;
      Modelica.Blocks.Math.Gain gain1(k=dataSource.getReal(setName + ".gain.k")) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
      Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(dataSource.getString(setName + ".gain.k"))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
      Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
      final parameter Integer m = dataSource.getArrayRows2D("table1") "Number of rows in 2D array";
      Modelica.Blocks.Sources.TimeTable timeTable(table=dataSource.getRealArray2D("table1", 3, 2)) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
      equation
        connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
        connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
      annotation(Documentation(info="<html><p>Component model that extends from <a href=\"modelica://ExternData.Interfaces.DataSourceModel\">DataSourceModel</a>.</p></html>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,0}, fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-150,150},{150,110}}, textString="%name", textColor={0,0,255})}));
    end Component;
    Component component annotation(Placement(transformation(extent={{-40,60},{-20,80}})));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain and table parameters in the component model from different nodes of the XML file <a href=\"modelica://ExternData/Resources/Examples/test.xml\">test.xml</a>. For component.gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XMLFile.getReal\">ExternData.XMLFile.getReal</a>. For component.gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XMLFile.getString\">ExternData.XMLFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). For component.timeTable the table parameter is read as Real array of dimension 3x2 by function <a href=\"modelica://ExternData.XMLFile.getRealArray2D\">ExternData.XMLFile.getRealArray2D</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XMLTest2;

  model XMLTest3 "XML file read test avoiding short-class definitions of external objects"
    extends Modelica.Icons.Example;
    function getReal "Get scalar Real value from XML file"
      extends Modelica.Icons.Function;
      input String fileName="" "File where external data is stored";
      input String varName "Key";
      output Real y "Real value";
      protected
        ExternData.Types.ExternXMLFile xml = ExternData.Types.ExternXMLFile(fileName) "External XML file object";
      algorithm
        y := ExternData.Functions.XML.getReal(xml=xml, varName=varName);
    end getReal;
    function getString "Get scalar String value from XML file"
      extends Modelica.Icons.Function;
      input String fileName="" "File where external data is stored";
      input String varName "Key";
      output String str "String value";
      protected
        ExternData.Types.ExternXMLFile xml = ExternData.Types.ExternXMLFile(fileName) "External XML file object";
      algorithm
        str := ExternData.Functions.XML.getString(xml=xml, varName=varName);
    end getString;
    parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xml") "XML file";
    Modelica.Blocks.Math.Gain gain1(k=getReal(fileName, setName + ".gain.k")) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(getString(fileName, setName + ".gain.k"))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain and table parameters from different nodes of the XML file <a href=\"modelica://ExternData/Resources/Examples/test.xml\">test.xml</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XMLFile.getReal\">ExternData.XMLFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XMLFile.getString\">ExternData.XMLFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XMLTest3;

  model XMLTest4 "XML file read test avoiding short-class definitions of external objects and only use one external object"
    extends Modelica.Icons.Example;
    final function getReal = ExternData.Functions.XML.getReal "Get scalar Real value from XML file";
    final function getString = ExternData.Functions.XML.getString "Get scalar String value from XML file";
    parameter String setName="set1" "Parameter set name" annotation(choices(choice="set1" "First parameter set", choice="set2" "Second parameter set"));
    parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.xml") "XML file";
    Modelica.Blocks.Math.Gain gain1(k=getReal(setName + ".gain.k", xml)) annotation(Placement(transformation(extent={{-15,60},{5,80}})));
    Modelica.Blocks.Math.Gain gain2(k=Modelica.Utilities.Strings.scanReal(getString(setName + ".gain.k", xml))) annotation(Placement(transformation(extent={{-15,30},{5,50}})));
    Modelica.Blocks.Sources.Clock clock annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    protected
	  final parameter ExternData.Types.ExternXMLFile xml = ExternData.Types.ExternXMLFile(fileName) "External XML file object";
	equation
      connect(clock.y,gain1.u) annotation(Line(points={{-29,70},{-17,70}}, color={0,0,127}));
      connect(clock.y,gain2.u) annotation(Line(points={{-29,70},{-22,70},{-22,40},{-17,40}}, color={0,0,127}));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the gain and table parameters from different nodes of the XML file <a href=\"modelica://ExternData/Resources/Examples/test.xml\">test.xml</a>. For gain1 the gain parameter is read as Real value using the function <a href=\"modelica://ExternData.XMLFile.getReal\">ExternData.XMLFile.getReal</a>. For gain2 the String value is retrieved by function <a href=\"modelica://ExternData.XMLFile.getString\">ExternData.XMLFile.getString</a> and converted to a Real value (using the utility function <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">Modelica.Utilities.Strings.scanReal</a>). The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end XMLTest4;

  model TIRTest "TIR file read test"
    extends Modelica.Icons.Example;
    inner parameter ExternData.TIRFile dataSource(fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/sample.tir")) "TIR file" annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.Constant pcx1(k=dataSource.getReal("PCX1", "LONGITUDINAL_COEFFICIENTS")) annotation(Placement(transformation(extent={{-50,60},{-30,80}})));
    Modelica.Blocks.Sources.Constant pcy1(k=dataSource.getReal("PCY1", "LATERAL_COEFFICIENTS")) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
    annotation(experiment(StopTime=1),
      Documentation(info="<html><p>This example model reads the tire coefficients from different sections of the TIR file <a href=\"modelica://ExternData/Resources/Examples/sample.tir\">sample.tir</a>. The coefficients are read as Real values using the function <a href=\"modelica://ExternData.TIRFile.getReal\">ExternData.TIRFile.getReal</a>. The read parameters are assigned by parameter bindings to the appropriate model parameters.</p></html>"));
  end TIRTest;
end Examples;
