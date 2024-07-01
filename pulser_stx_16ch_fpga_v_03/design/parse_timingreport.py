#!/usr/bin/python

class ParseTiming(object):
    """docstring for ParseTiming"""
    def __init__(self,):
        super(ParseTiming, self).__init__()
        self.fh_setup = self.open_report('build_app/TQ_paths_setup.txt')
        self.fh_hold = self.open_report('build_app/TQ_paths_hold.txt')
        self.fh_recovery = self.open_report('build_app/TQ_paths_recovery.txt')
        self.fh_removal = self.open_report('build_app/TQ_paths_removal.txt')
        self.parse("Setup", self.fh_setup)
        self.parse("Hold", self.fh_hold)
        self.parse("Recovery", self.fh_recovery)
        self.parse("Removal", self.fh_removal)

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

    def clean_number(self, text):
        idx = text.find('(')
        return float(text) if idx < 0 else float(text[:idx])

    def truncate(self, text):
        if len(text) > 40:
            html = '<a data-toggle="tooltip" data-placement="bottom" title="%s">' % text
            html += text[:20] + '...' + text[-20:] + '</a>'
            return html
        else:
            return text

    def parse(self, corner, fh):
        html = self.open_html("html/views/timing_%s.html" % corner.lower())
        # Building HTML
        header = '<div class="container-fluid">'
        header += '<div class="row" style="padding:50px">'
        header += '<h3>%s paths</h3>' % corner
        header += '<table class="table table-hover">'
        header += '<tr><th>Slack</th><th>From node</th><th>To node</th><th>Launch clock</th><th>Latch clock</th><th>Relationship</th><th>Clock Skew</th><th>Data Delay</th></tr>'
        html.write(header + '\n')

        watch = False
        for idx, line in enumerate(fh.readlines()):
            if line.startswith("; Summary of Paths "):
                watch = True
            elif line.startswith("Path #1"):
                break
            elif line.startswith("+------") or line.rstrip() == "":
                pass
            elif watch:
                if line.rstrip().startswith("; Slack"):
                    legend = line[1:-2].replace(" ", "").split(';')

                else:
                    data = line[1:-2].replace(" ", "").split(';')
                    option = ""
                    text = '<tr>'
                    if float(data[0]) < 0:
                        option = ' style="color: red"'

                    for item in data:
                        text += '<td%s>%s</td>' % (option, self.truncate(item))
                    text += '</td>\n'
                    html.write(text)



        footer = '</table></div></div>'
        html.write(footer + '\n')
        html.close()

if __name__ == '__main__':
    fit = ParseTiming()
