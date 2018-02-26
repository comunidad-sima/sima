
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using Excel = Microsoft.Office.Interop.Excel;
using System.IO;

namespace WebSima.clases
{
    public class ExcelDato
    {
        //public System.Web.Mvc.FileResult Download()
        //{
        //    Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

        //    Microsoft.Office.Interop.Excel.Workbook xlWorkBook;
        //    Microsoft.Office.Interop.Excel.Worksheet xlWorkSheet;

        //    object misValue = System.Reflection.Missing.Value;

        //    xlWorkBook = xlApp.Workbooks.Add(misValue);
        //    xlWorkSheet = (Microsoft.Office.Interop.Excel.Worksheet)xlWorkBook.Worksheets.get_Item(1);

        //    xlWorkSheet.Cells[1, 1] = "ID";
        //    xlWorkSheet.Cells[1, 2] = "Name";
        //    xlWorkSheet.Cells[2, 1] = "1";
        //    xlWorkSheet.Cells[2, 2] = "One";
        //    xlWorkSheet.Cells[3, 1] = "2";
        //    xlWorkSheet.Cells[3, 2] = "Two";


        //    var path = "C:\\Work-Work\\TestFolder\\XCLbuildTry1\\csharp-Excel.xls";
        //    xlWorkBook.SaveAs(path);
        //    xlWorkBook.Close(true, misValue, misValue);
        //    xlApp.Quit();

        //    Marshal.ReleaseComObject(xlWorkSheet);
        //    Marshal.ReleaseComObject(xlWorkBook);
        //    Marshal.ReleaseComObject(xlApp);
        //    var f = File(path, "application/vnd.ms-excel", "WidgetData.xlsx");
        //    return f;
        //}
    }
}