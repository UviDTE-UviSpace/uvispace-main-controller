#!/usr/bin/env python
"""
Auxiliary program for saving poses in spreadsheet and text file.
"""
# Standard libraries
import sys
#Excel read/write library
from openpyxl import Workbook
from openpyxl import load_workbook

def data_to_spreadsheet(data, filename_spreadsheet):
    """
    Receives poses and time, and saves them in a spreadsheet.

    :param data: contains data to save in spreadsheet.
    :param filename_spreadsheet: name of spreadsheet where the data
     will be saved.
    """
    try:
        wb = load_workbook(filename_spreadsheet)
    except:
        wb = Workbook()       
    ws = wb.active
    empty_row = 0
    search_empty_row = True
    # Detects the next empty row.
    while search_empty_row:
        empty_row += 1
        data = ws.cell(row=empty_row, column=1).value
        if data is None:
            search_empty_row = False
    # Write data in empty row.
    for index, element in enumerate(data):
        ws.cell(column=index+1, row=empty_row, value=element)
    wb.save(filename_spreadsheet)

def data_to_textfile(data, filename_textfile):
    """
    Receives poses and time, and saves them in a textfile.

    :param data: contains data to save in a textfile.
    :param filename_textfile: name of textfile where the data will
     be saved.
    """
    outfile = open(filename_textfile, 'a')
    for index, element in enumerate(data):
        text = text + "{} \t".format(element)
    #text = ("{} \t {pose1} \t {pose2} \t {pose3} \n".format(time=current_time,
                            #mpose[0], mpose[1], mpose[2])
    outfile.write(text)
    outfile.close()
