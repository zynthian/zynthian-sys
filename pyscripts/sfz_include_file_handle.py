import os
import re
import socket
import logging
import argparse

from time import sleep
from os.path import isfile, isdir, join
from subprocess import check_output
from collections import OrderedDict
from copy import deepcopy
from datetime import datetime

import pyparsing as pp


log_file = 'sfz_include_file_handle.log'
logging.basicConfig(filename=log_file, filemode='w',level=logging.DEBUG)


# pyparsing elements
# File Extensions

#include "S1.sfz"

include_file_new_ext = 'i'
sfz_ext = '.sfz'

full_sfz_include_ext = 'sfzi'    # notice lack of '.'

filename = pp.Suppress('"') +\
           pp.Word(pp.alphanums +'.'+'_') +\
           pp.Suppress('"')



filename_body = pp.Word(pp.alphanums +'_')('filename_body')
filename_ext =  pp.Word(pp.alphanums + '_')('extension')
filename_treated_ext = pp.Literal(full_sfz_include_ext)('treated_ext')


filename_with_treated_ext = filename_body +\
                pp.Suppress('.') +\
                filename_treated_ext('filename_with_treated_ext')

filename_with_ext = filename_body +\
                pp.Suppress('.') +\
                filename_ext('filename_with_ext')

filename_without_ext = filename_body('filename_without_ext')



filename_with_ext_in_quotes = pp.Suppress('"') +\
                              filename_with_ext +\
                              pp.Suppress('"')

filename_with_treated_ext_in_quotes = pp.Suppress('"') +\
                              filename_with_treated_ext +\
                              pp.Suppress('"')

                            
filename_without_ext_in_quotes = pp.Suppress('"') +\
                filename_without_ext +\
                pp.Suppress('"')


inc_fnoextq = pp.Suppress('#include') +\
           filename_without_ext_in_quotes

inc_fextq = pp.Suppress('#include') +\
           filename_with_ext_in_quotes

inc_ftextq = pp.Suppress('#include') +\
           filename_with_treated_ext_in_quotes

incfile = pp.MatchFirst([inc_ftextq, inc_fextq, inc_fnoextq])

repeated_sfz_inc = sfz_ext + \
                  pp.OneOrMore(include_file_new_ext)('inc_repeated')         

treated_filename= pp.Suppress('"') +\
                  pp.Word(pp.alphanums +'_') +\
                  repeated_sfz_inc +\
                  pp.Suppress('"')

full_treated_filename = pp.Combine(treated_filename)('full_treated_filename')

full_filename = pp.Combine(filename)

include = pp.Suppress('#') +\
 pp.Literal('include')+\
 full_filename('included')


include_no_ext = pp.Suppress('#') +\
 pp.Literal('include')+\
 pp.Suppress('"') +\
 pp.Word(pp.alphanums) +\
 pp.Suppress('"')

full_include_no_ext = pp.Combine(include_no_ext)('included_noext')

treated_include = pp.Suppress('#') +\
 pp.Literal('include')+\
 full_treated_filename('treated')

includes = pp.MatchFirst([treated_include, full_include_no_ext, include])




class SFZIncHandle(object):
    def __init__(
        self,
        directory,
        verbosity=2,
        log_file = 'fix.log',
        just_log=False):

        self.directory = directory
        self.verbosity = verbosity
        self.just_log = just_log
        self.log_file = log_file
        
        self.preset_set = set()
        self.kicked_set = set()
        
    
    def vprint(self, text):
        if self.verbosity > 2:
            logging.info(text)

    def treat_file(self,
        row,
        old_file_name,
        new_file_name,
        filehead,
        sfzfile):
        sfzfilehead, sfzfiletail = os.path.split(sfzfile)
        old_full_file_name = os.path.join(filehead, old_file_name)
                
        self.kicked_set.add(
            old_full_file_name
            )
        self.vprint('SFZFile "{}" "{}" changed to "{}"'.format(
            sfzfile,
            old_file_name,
            new_file_name
            ))
                
        if self.just_log:
            return row
                
        row =  row.replace(old_file_name, new_file_name)
        with open(os.path.join(filehead, self.log_file), 'a') as fp:
            fp.write('SFZFile "{}" from "{}" to "{}"\n'.format(sfzfiletail, old_file_name, new_file_name))

        return row

    def find_files(self):
        self.vprint('Considering:-"{}"'.format(self.directory))
        if os.path.isdir(self.directory):
            self.vprint('Found Directory:-"{}"'.format(self.directory))
            cmd="find '" + self.directory + "' -maxdepth 5 -type f -name '*.sfz'"

            self.vprint('Command:-"{}"'.format(cmd))
            output=check_output(cmd, shell=True).decode('utf8')
            cmd="find '"+ self.directory +"' -maxdepth 5 -type f -name '*.gig'"
            output=output+"\n"+check_output(cmd, shell=True).decode('utf8')
            return output.split('\n')
        return []

    def parse_lines(self, lines):
        for f in lines:    
            if os.path.isfile(f):
                filehead,filetail=os.path.split(f)
                tmp_file = os.path.join(filehead, filetail+'~')
                        
                self.preset_set.add(f)
                                
                with open(f,'r', newline='') as infile:                    
                    with open(tmp_file, 'w', newline='') as outfile:
                        rowIter= iter(infile)
                        for row in rowIter:
                            for result, start, stop in incfile.scanString(row):
                                try:
                                    # Ignore treated lines
                                    result['filename_with_treated_ext']
                                except KeyError:                  
                                    try:
                                        result['filename_with_ext']
                                                            
                                        old_file_name = '{}.{}'.format(
                                            result['filename_body'],
                                            result['filename_with_ext']
                                            )
                                                                    
                                        new_file_name = '{}.{}'.format(
                                            result['filename_body'],
                                            full_sfz_include_ext
                                            )
                                                            
                                        row = self.treat_file(
                                            row,
                                            old_file_name,
                                            new_file_name,
                                            filehead,
                                            f
                                            )
                                    except KeyError:
                                        pass
                                    try:
                                        result['filename_without_ext']

                                        old_file_name = '{}'.format(
                                            result['filename_without_ext']
                                            )
                                        new_file_name = '{}.{}'.format(
                                            result['filename_without_ext'],
                                            full_sfz_include_ext
                                            )

                                        row = self.treat_file(
                                            row,
                                            old_file_name,
                                            new_file_name,
                                            filehead,
                                            f
                                            )
                                    except KeyError:
                                        pass
          
                            outfile.write(row)
                                                
                    if tmp_file and f:                     
                        os.rename(tmp_file, f)

    def rename_files(self):
        # Rename files in kicked_set . . .

        for kicked_file in self.kicked_set:
            filehead, filetail= os.path.split(kicked_file)
            body, ext = os.path.splitext(filetail)
            if ext:
                    new_file = os.path.join(
                            filehead,
                            filetail.replace(ext, '.' + full_sfz_include_ext)
                            )
            else:
                    new_file = os.path.join(
                            filehead,
                            filetail + '.'+ full_sfz_include_ext
                            )
                
            self.vprint('Renaming "{}" to "{}"'.format(
                kicked_file,
                os.path.split(new_file)[1]))

            if not self.just_log:
                try:
                    os.rename(kicked_file, new_file)
                    
                    with open(os.path.join(filehead, self.log_file), 'a') as fp:
                        fp.write('Renamed "{}" to "{}"\n'.format(
                            os.path.split(kicked_file)[1],
                            os.path.split(new_file)[1]))
                        
                except FileNotFoundError:
                    with open(os.path.join(filehead, self.log_file), 'a') as fp:
                        message = 'Renamed FAILED... "{}" to "{}"\n'.format(
                            kicked_file,
                            os.path.split(new_file)[1])
                        fp.write(message)
                        logging.error(message)
                except Exception as e:
                    logging.error('An exception {}'.format(e))
        
if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        description=
        """Parse directories (-d) and their children for sfz files and if
they include #include statements change the entry to one with the correct extention (.sfxi)
and then rename the appropriate file.
logs (fix.log) into the appropiate directory to indicate action.
Can be run repeatedly with no ill effects.

It can take some time to run . . . ~ minutes.
"""
        )

    parser.add_argument(
        "directory",
        help="The directory and its (children to depth 5) to be processed"
        )
    parser.add_argument(
        "-f",
        "--fake",
        help="Fake the run just print debugging info (verbosity 3)",
        action="store_true"
        )
    parser.add_argument(
        "-v",
        "--verbosity",
        help="Verbosity level (2 is silent, 3 is more verbose)",
        default=2,
        type=int
        )
    args = parser.parse_args()

    if args.fake:
        args.verbosity = 3
    
    
    sih = SFZIncHandle(
        # directory='/home/chris/zynthian/development/data/soundfonts/sfz',
        directory=args.directory,
        verbosity=args.verbosity,
        log_file='fix.log',
        just_log=args.fake)

    lines = sih.find_files()
    sih.parse_lines(lines)
    sih.rename_files()

    with open(log_file) as fp:
        print(fp.read())

    
