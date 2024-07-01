#!/usr/bin/python

class ParseMapMessages(object):
    """docstring for ParseMapMessages"""
    def __init__(self, ):
        super(ParseMapMessages, self).__init__()
        self.fh = self.open_report('build_app/stx2_tenrec_fpga.map.rpt')
        self.parse()

    def open_report(self, filename):
        try:
            return open(filename, 'r')
        except Exception as e:
            raise e

    def open_html(self, filename):
        try:
            return open(filename, 'w')
        except Exception as e:
            raise e

    def find_indentation(self, text):
        for idx, item in enumerate(text):
            if item != " ":
                return idx

    def parse(self, ):
        watch = False
        html = self.open_html("html/views/message_map.html")
        header = '<div class="container-fluid">'
        header += '<div class="row" style="padding:50px">'
        header += '<h3>Analysis & Synthesis messages</h3><p>'
        header += '<table class="table table-hover">'
        header += '<tr><th>Type</th><th>ID</th><th>Message</th></tr>'
        html.write(header + '\n')
        warn = 0
        crit = 0
        info = 0

        for idx, line in enumerate(self.fh.readlines()):

            if line.startswith("; Analysis & Synthesis Messages"):
                watch = True
            elif line.startswith("; Analysis & Synthesis Suppressed Messages"):
                break
            elif watch == True:
                indent = self.find_indentation(line)
                colon = line.find(':')
                t0 = line[:colon]
                t1 = line[colon + 1 :]
                stripped = t0.replace(' ', '')
                if stripped.startswith('Info') or stripped.startswith('Extra'):
                    info += 1
                    mesg_type = 'Info'
                    var = "showInfo"
                elif stripped.startswith('Critical'):
                    crit += 1
                    mesg_type = 'Critical Warning'
                    var = "showCrit"
                elif stripped.startswith('Warning'):
                    warn += 1
                    mesg_type = 'Warning'
                    var = "showWarn"
                else:
                    info += 1
                    mesg_type = ''
                    var = "showInfo"

                # Looking for ID
                id_start = t0.find('(') + 1
                id_end = t0.find(')')
                if id_start > 0:
                    mesg_id = t0[id_start:id_end]
                else:
                    mesg_id = ''

                text = '<tr ng-show="%s"><td>%s</td><td>%s</td><td style="text-indent:%dpx">%s</td></tr>\n' % (var, mesg_type, mesg_id, indent * 4, t1)
                html.write(text)



        footer = '</table>'
        footer += '<nav class="navbar navbar-default navbar-fixed-bottom">'
        footer += '<div style="padding: 10px">'
        footer += '<button ng-click="showInfo = !showInfo" ng-init="showInfo=true" class="btn btn-sm btn-primary" type="button">'
        footer += '<i ng-show="showInfo" class="fas fa-folder-minus"></i><i ng-hide="showInfo" class="fas fa-folder-plus"></i>'
        footer += ' Info <span class="badge"><small>%d</small></span>' % info
        footer += '</button>'
        footer += '<button ng-click="showWarn = !showWarn" ng-init="showWarn=true" class="btn btn-sm btn-primary" type="button">'
        footer += '<i ng-show="showWarn" class="fas fa-folder-minus"></i><i ng-hide="showWarn" class="fas fa-folder-plus"></i>'
        footer += ' Warning <span class="badge"><small>%d</small></span>' % warn
        footer += '</button>'
        footer += '<button ng-click="showCrit = !showCrit" ng-init="showCrit=true" class="btn btn-sm btn-primary" type="button">'
        footer += '<i ng-show="showCrit" class="fas fa-folder-minus"></i><i ng-hide="showCrit" class="fas fa-folder-plus"></i>'
        footer += ' Critical warnings <span class="badge"><small>%d</small></span>' % crit
        footer += '</button>'
        footer += '</div>'
        footer += '</nav>'
        footer += '</div></div>'
        html.write(footer + '\n')
        html.close()

if __name__ == '__main__':
    fit = ParseMapMessages()
