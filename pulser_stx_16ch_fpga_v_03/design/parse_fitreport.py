#!/usr/bin/python

class ParseFit(object):
    """docstring for ParseFit"""
    def __init__(self, filename):
        super(ParseFit, self).__init__()
        self.fh_summary = open('html/views/summary.html', 'w')
        self.fh_resources = open('html/views/resources.html', 'w')
        self.line_buffer = list()
        self.resources = dict()
        self.level = 0
        self.hierarchy = list()
        self.filename = filename

    def open_report(self, filename):
        try:
            return open(filename, 'r')
        except Exception as e:
            raise e

    def clean_number(self, text):
        idx = text.find('(')
        return float(text) if idx < 0 else float(text[:idx])

    def parse(self, ):
        self.get_summary()
        self.get_resources()

    def get_resources(self, ):
        self.fh = self.open_report(self.filename)
        idx = 0
        res = dict()
        watch = False
        queryData = ['ALMsusedformemory', 'CombinationalALUTs',
                     'DedicatedLogicRegisters', 'M10Ks', 'BlockMemoryBits',
                     'DSPBlocks']
        self.fh_resources.write('<div class="container-fluid">\n')
        self.fh_resources.write('<div class="row" style="padding:50px">\n')
        header = '<table class="table table-hover"><tr class="th0">'
        header += '<th>Module name</th><th>M10Ks</th><th>DSP</th><th>Registers</th><th>Comb. LUTs</th></tr>\n'

        self.fh_resources.write(header)
        for line in self.fh.readlines():
            if line.startswith("; Fitter Resource Utilization by Entity"):
                watch = True
            elif line.startswith("; Delay Chain Summary"):
                break
            elif watch == True:
                indent = line.find('|')
                line2 = line[1:-2].rstrip().replace(" ", "").split(';')
                if line.startswith("; Compilation Hierarchy Node"):
                    legend = line2
                elif line.startswith(";"):
                    idx += 1
                    level = (indent - 2) / 3

                    name = line2[legend.index('FullHierarchyName')][1:]
                    prop = dict()
                    split_name = name.split('|')
                    prop['hierarchy'] = split_name
                    prop['modules'] = list()
                    prop['level'] = level
                    prop['name'] = split_name[-1]

                    for item in queryData:
                        prop[item] = int(self.clean_number(line2[legend.index(item)]))

                    indent = prop['level'] * 10

                    html = '<tr><td style="text-indent:%dpx">%s</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>\n' % (indent, prop['name'], prop['M10Ks'], prop['DSPBlocks'], prop['DedicatedLogicRegisters'], prop['CombinationalALUTs'])
                    self.fh_resources.write(html)

                    # if idx == 10:
                    #     break

        self.fh_resources.write('</table>')
        self.fh_resources.write('</row>')
        self.fh_resources.write('</div>')
        self.fh_resources.close()

        self.fh.close()


    def get_summary(self):
        self.fh = self.open_report(self.filename)
        tmp = list()
        watch = False
        for line in self.fh.readlines():
            if line.startswith("; Fitter Summary"):
                watch = True
                continue
            elif line.startswith("; Fitter Settings"):
                watch = False
                break

            if watch and line.startswith(";"):
                tmp.append(line[1:-2].split(';'))
        self.fh.close()
        self.html_table(self.fh_summary, tmp)

    def html_table(self, fh, text):
        fh.write('<div class="container-fluid">\n')
        fh.write('<div class="row" style="padding:50px">\n')
        fh.write('<table class="table table-hover" style="width:70%">\n')
        for line in text:
            fh.write('<tr>')
            fh.write('<td>%s</td>' % line[0])
            fh.write('<td>%s</td>' % line[1])
            fh.write('</tr>\n')
        fh.write('</table>\n')
        fh.write('</div>\n')
        fh.write('</div>\n')

if __name__ == '__main__':
    fit = ParseFit('build_app/stx2_tenrec_fpga.fit.rpt')
    fit.parse()
