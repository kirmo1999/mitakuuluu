/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Andrew den Exter <andrew.den.exter@jollamobile.com>
** All rights reserved.
**
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0

TextBase {
    id: textArea

    property alias text: preeditText.text
    property alias textWidth: textEdit.width
    property alias readOnly: textEdit.readOnly
    property alias inputMethodHints: textEdit.inputMethodHints
    property alias inputMethodComposing: textEdit.inputMethodComposing
    property alias cursorPosition: textEdit.cursorPosition
    property alias wrapMode: textEdit.wrapMode
    property alias verticalAlignment: textEdit.verticalAlignment
    property alias selectedText: textEdit.selectedText
    property alias selectionStart: textEdit.selectionStart
    property alias selectionEnd: textEdit.selectionEnd
    property alias lineCount: textEdit.lineCount

    _editor: textEdit

    property int maxHeight: 300

    implicitHeight: Math.min(maxHeight, textEdit.height + _labelItem.height +
                             (readOnly ? Theme.paddingMedium : Theme.paddingSmall) + Theme.paddingSmall + 2)
    background: null

    _flickableDirection: Flickable.VerticalFlick

    anchors.left: parent.left
    anchors.right: parent.right

    textLeftMargin: showEmoji ? Theme.itemSizeSmall : Theme.paddingLarge
    textRightMargin: showAction ? Theme.itemSizeSmall: Theme.paddingLarge

    property bool showEmoji: false
    property bool showAction: false

    property alias actionButton: sendButton

    property alias emojiChecked: emojiButton.checked
    signal action
    signal emojiClicked

    Rectangle {
        id: emojiButton
        width: Theme.itemSizeExtraSmall
        height: width
        radius: width / 2
        border.width: 2
        border.color: checked ? Theme.secondaryHighlightColor : Theme.secondaryColor
        color: "transparent"
        property bool checked: false

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingSmall
        anchors.left: parent.left
        anchors.leftMargin: - Theme.itemSizeExtraSmall
        visible: showEmoji

        MouseArea {
            anchors.fill: parent
            onClicked: {
                emojiButton.checked = !emojiButton.checked
                textArea.emojiClicked()
            }
        }
    }

    IconButton {
        id: sendButton
        icon.source: "image://theme/icon-m-message"
        highlighted: enabled
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingSmall
        anchors.right: parent.right
        anchors.rightMargin: - Theme.itemSizeExtraSmall
        visible: showAction
        onClicked: {
            textArea.action()
        }
    }

    TextEdit {
        id: textEdit
        objectName: "textEditor"

        property alias _preeditText: preeditText // for TextAutoScroller

        x: -parent.contentX
        y: -parent.contentY
        width: textArea.width - Theme.paddingSmall - textArea.textLeftMargin - textArea.textRightMargin
        horizontalAlignment: textArea.horizontalAlignment
        focus: true
        activeFocusOnPress: false
        color: textArea.color
        selectionColor: Qt.rgba(1.0, 1.0, 1.0, 0.3)
        selectedTextColor: Theme.highlightColor
        font: textArea.font
        cursorDelegate: Rectangle {
            color: textArea.cursorColor
            visible: parent.activeFocus && !parent.readOnly && parent.selectedText == ""
            width: 2
        }
        wrapMode: TextEdit.Wrap

        // Note: need to disable if textFormat is ever allowed to be more than TextEdit.PlainText
        PreeditText {
            id: preeditText
        }
    }
}
