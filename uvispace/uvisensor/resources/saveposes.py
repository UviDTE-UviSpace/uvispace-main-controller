#!/usr/bin/env python
"""
Auxiliary program for saving and erasing poses in spreadsheet and text
file.
"""
# Standard libraries
import sys
#Excel read/write library
from openpyxl import Workbook
from openpyxl import load_workbook

def save_data_spreadsheet(current_time, mpose, filename_spreadsheet):
    """
    Receives poses with its corresponding time and saves them in a
    spreadsheet.

    :param current_time: contains time corresponding to the pose.
    :param mpose: contains a 2-D position, with 2 cartesian values
     (x,y) and an angle value (theta).
    :param filename_spreadsheet: name of spreadsheet where the data
     will be saved.
    """
    wb = load_workbook(filename_spreadsheet)
    ws = wb.active
    empty_row = 0
    search_empty_row = True
    # Detects the next empty row.
    while search_empty_row == True:
        empty_row += 1
        data = ws.cell(row = empty_row, column = 1).value
        if data == None:
            search_empty_row = False
    # Write data in empty row.
    ws.cell(column=1, row=empty_row, value=current_time)
    ws.cell(column=2, row=empty_row, value=mpose[0])
    ws.cell(column=3, row=empty_row, value=mpose[1])
    ws.cell(column=4, row=empty_row, value=mpose[2])

    wb.save(filename_spreadsheet)

def save_data_textfile(current_time, mpose, filename_textfile):
    """
    Receives poses with its corresponding time and saves them in a
    filetext.
    :param current_time: contains time corresponding to the pose.
    :param mpose: contains a 2-D position, with 2 cartesian values
     (x,y) and an angle value (theta).
    :param filename_textfile: name of textfile where the data will
     be saved.
    """
    outfile = open(filename_textfile, 'a')
    text = ("%f \t%f \t%f \t%f \n") % (current_time, mpose[0], mpose[1],
                                       mpose[2])
    outfile.write(text)
    outfile.close()
