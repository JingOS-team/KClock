function setScreenDisplay(x,y){
    screenWidth = x
    screenHeight = y
}

var screenWidth = 1920
var screenHeight = 1200
var testHeight = 1080
var defaultBkgColor = "#D8D8D8"
var monthView = {
    "width":1340,
    "header_commonMargin":50,
    "header_leftMargin":50,
    "header_topMargin":50,
    "header_rightMargin":50,
    "header_bottomMargin":50,
    "dayRectWidth":180
}

var dayDelegate = {
    "width":180,
    "event_circle":14,
    "rect_radius":24,
    "today_rect_color":"#E95B4E"
}
var calendarScheduleView = {
    "width":560,
    "common_margin":40,
    "content_margin":18,
    "listView_topMargin":40,
    "section_listView_height":80,
    "lable_color_height":6,
}

var popEventEditor = {
     "common_margin":20,
     "icon_margin":30,
     "column_spacing":15,
     "icon_text_margin":10
}

var timeSelectWheelView = {
    "bg_color":"#EFEFF0"
}

var dateSelectWheelView = {
    "bg_color":"#EFEFF0"
}

var fontSize = {
    "f1_5":Kirigami.Units.fontMetrics.font.pointSize * 1.5,
    "f1_6":Kirigami.Units.fontMetrics.font.pointSize * 1.6,
    "f1_8":Kirigami.Units.fontMetrics.font.pointSize * 1.8,
    "f2":Kirigami.Units.fontMetrics.font.pointSize * 2,
    "f2_5":Kirigami.Units.fontMetrics.font.pointSize * 2.5,
    "f3":Kirigami.Units.fontMetrics.font.pointSize * 3,
    "f4":Kirigami.Units.fontMetrics.font.pointSize * 4
}

