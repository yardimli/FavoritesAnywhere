object Form2: TForm2
  Left = 183
  Top = 188
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Folder Properties'
  ClientHeight = 333
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    00000000000000000004CEC0000000000000000000000000004CEEC000000000
    000000000000000004CEECC00000000000000000000000004CEECC0000000000
    0000000000000004CEECC00000007333333333333333334CEECC033333307FB8
    B8B8B8B8B8B8B4CEECC038B8B8307F8B8B8B8B8B8B8B7CEECC038B8B8B307FB8
    B8B8B8B8B8B78FECC038B8B8B8307F8B8B8B80000078F87C038B8B8B8B307FB8
    B8B006666600877038B8B8B8B8307F8B8B768E8E8E6607038B8B8B8B8B307FB8
    B768E8E8E8E66038B8B8B8B8B8307F8B878EFE8E8E8E60788B8B8B8B8B307FB8
    78EFE8E8E8E8E607B8B8B8B8B8307F8B7EFEFE8E8E8E86038B8B8B8B8B307FB8
    78EFF8E8E8E8E607B8B8B8B8B8307F8B7EFEFF8E8E8E86038B8B8B8B8B307FB8
    78EFFFE8E8E8E607B8B8B8B8B8307F8B87FEFFFE8E8E80388B8B8B8B8B307FB8
    B78FEFEFE8E86038B8B8B8B8B8307F8B8B78FEFEFE86078B8B8B8B8B8B307FB8
    B8B778E8E70078B8B8B8B8B8B8307F8B8B8B877770338B8B8B8B8B8B8B307FB8
    B8B8B8B8B8B8B8B8B8B8B8B8B8307FFFFFFFFFFFFFFFFFFFFFFFFFFFFF007888
    888888888888777777777777770007FB8B8B8B8B8B870000000000000000007F
    B8B8B8B8B87000000000000000000007FFFFFFFFF70000000000000000000000
    7777777770000000000000000000FFFFFF1FFFFFFE0FFFFFFC0FFFFFF80FFFFF
    F01F800000010000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000001000000038000
    FFFFC001FFFFE003FFFFF007FFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    00000004EC0000000000004ECC000000000004ECC000733333334ECC33007FB8
    70078CC3B3007F878E80733B83007F7FE8E803B8B3007F7EFE8E038B83007F7F
    EFE807B8B3007F87FEF07B8B83007FB87707B8B8B3007FFFFFFFFFFFF30078B8
    B8B877777700078B8B87000000000077777000000000FFF30000FFE10000FFC1
    0000800300000001000000010000000100000001000000010000000100000001
    000000010000000100000003000080FF0000C1FF0000}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 193
    Top = 0
    Width = 3
    Height = 314
    Cursor = crHSplit
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 193
    Height = 314
    Align = alLeft
    Indent = 19
    ReadOnly = True
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 196
    Top = 0
    Width = 322
    Height = 314
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = '&Properties'
      object Label1: TLabel
        Left = 3
        Top = 53
        Width = 62
        Height = 13
        Caption = 'Sub Folders :'
      end
      object Label2: TLabel
        Left = 3
        Top = 32
        Width = 49
        Height = 13
        Caption = 'Favorites :'
      end
      object Label3: TLabel
        Left = 3
        Top = 12
        Width = 66
        Height = 13
        Caption = 'Folder Name :'
      end
      object Label5: TLabel
        Left = 3
        Top = 73
        Width = 66
        Height = 13
        Caption = 'Date Created:'
      end
      object Label7: TLabel
        Left = 3
        Top = 93
        Width = 307
        Height = 46
        AutoSize = False
        Caption = 'Physical Path :'
        WordWrap = True
      end
      object BitBtn2: TBitBtn
        Left = 3
        Top = 255
        Width = 75
        Height = 25
        Caption = '&Close'
        TabOrder = 0
        OnClick = BitBtn2Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Modify'
      ImageIndex = 1
      object Label4: TLabel
        Left = 3
        Top = 12
        Width = 46
        Height = 13
        Caption = 'Rename :'
      end
      object BitBtn3: TBitBtn
        Left = 3
        Top = 255
        Width = 75
        Height = 25
        Caption = '&Close'
        TabOrder = 0
        OnClick = BitBtn3Click
      end
      object BitBtn4: TBitBtn
        Left = 3
        Top = 60
        Width = 75
        Height = 25
        Caption = '&Rename'
        TabOrder = 1
        OnClick = BitBtn4Click
      end
      object Edit1: TEdit
        Left = 3
        Top = 33
        Width = 307
        Height = 21
        TabOrder = 2
        Text = 'Edit1'
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&Delete'
      ImageIndex = 2
      object Label6: TLabel
        Left = 3
        Top = 9
        Width = 244
        Height = 49
        AutoSize = False
        Caption = 
          'WARNING!! If you delete a folder all subfolders and all the favo' +
          'rites within will be deleted too. There is no undo to this opera' +
          'tion.'
        WordWrap = True
      end
      object Button2: TButton
        Left = 3
        Top = 54
        Width = 75
        Height = 25
        Caption = '&Delete'
        TabOrder = 0
        OnClick = Button2Click
      end
      object BitBtn1: TBitBtn
        Left = 3
        Top = 255
        Width = 75
        Height = 25
        Caption = '&Close'
        TabOrder = 1
        OnClick = BitBtn3Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = '&Move'
      ImageIndex = 3
      object Label8: TLabel
        Left = 3
        Top = 162
        Width = 307
        Height = 40
        AutoSize = False
        Caption = 'Source :'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 3
        Top = 207
        Width = 307
        Height = 40
        AutoSize = False
        Caption = 'Destination :'
        WordWrap = True
      end
      object Label10: TLabel
        Left = 3
        Top = 3
        Width = 125
        Height = 13
        Caption = 'Please select target folder.'
      end
      object TreeView2: TTreeView
        Left = 3
        Top = 21
        Width = 307
        Height = 136
        Indent = 19
        ReadOnly = True
        SortType = stText
        TabOrder = 0
        OnClick = TreeView2Click
      end
      object BitBtn5: TBitBtn
        Left = 84
        Top = 255
        Width = 75
        Height = 25
        Caption = '&Close'
        TabOrder = 1
        OnClick = BitBtn2Click
      end
      object BitBtn6: TBitBtn
        Left = 3
        Top = 255
        Width = 75
        Height = 25
        Caption = '&Move'
        TabOrder = 2
        OnClick = BitBtn6Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 314
    Width = 518
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
