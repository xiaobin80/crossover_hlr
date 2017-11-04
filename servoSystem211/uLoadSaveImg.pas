unit uLoadSaveImg;

interface
uses
  SysUtils, Classes, Graphics, Jpeg, DB, ADODB;

//这里的图形属性顺序是随意安排的，可自行修改，现在的顺序和FastReport相同，在FastReport中打印图像//时可用返回的图形属性设置 FastReport 的Picture 组件的 BlobType。
//procedure TForm1.frReportBeforePrint(Memo: TStringList; View: TfrView);
//begin
//　if (View is TfrPictureView) and ((View as TfrPictureView).Name = ’Picture1’) then
//　begin
//　　(View as TfrPictureView).BlobType := LSImg.LoadFromStream(Stream);
//　　(View as TfrPictureView).Picture.Assign(LSImg.Picture1.Picture);
//　end;
//end;

const
  pkBitmap = 0;
  pkJPEG = 1;
  pkIcon = 2;
  pkMetafile = 3;
  pkNone = 4;

type
  TLSImg = class(TObject)
  private
  public
    Picture: TPicture;
    Graphic: TGraphic;
    constructor Create;
    destructor Destroy; override;
    function GetImgType(const FileType: string): Byte;
    function LoadFromStream(Stream: TMemoryStream): byte;
    function SaveToStream(Stream: TMemoryStream): byte;
  end;

implementation

constructor TLSImg.Create;
begin
  Picture := TPicture.Create;
  inherited Create;
end;

destructor TLSImg.Destroy;
begin
  Picture.Free;
  inherited Destroy;
end;

//根据输入的文件类型调用相应的驱动程序

function TLSImg.GetImgType(const FileType: string): Byte;
begin
  Result := pkNone;
  if FileType <> '' then
    if UpperCase(FileType) = 'BMP' then
      Result := pkBitmap
    else if (UpperCase(FileType) = 'EMF') or (UpperCase(FileType) = 'WMF') then
      Result := pkMetafile
    else if UpperCase(FileType) = 'ICO' then
      Result := pkIcon
    else if (UpperCase(FileType) = 'JPE') or (UpperCase(FileType) = 'JPG') or
      (UpperCase(FileType) = 'JPEG') then
      Result := pkJPEG;
  Graphic := nil;
  case Result of
    pkBitmap: Graphic := TBitmap.Create;
    pkMetafile: Graphic := TMetafile.Create;
    pkIcon: Graphic := TIcon.Create;
    pkJPEG: Graphic := TJPEGImage.Create;
  end;
  if Graphic <> nil then
  begin
    Picture.Graphic := Graphic;
    Graphic.Free;
  end;
end;

//从文件头读图像的种类，然后加载相应的驱动，这里文件长度暂时没有使用
function TLSImg.LoadFromStream(Stream: TMemoryStream): byte;
var
  n: Integer;
begin
  Stream.Seek(0, soFromBeginning);
  //读文件属性
  Stream.Read(Result, 1);
  //读文件长
  Stream.Read(n, 4);
  Graphic := nil;
  //调用相应的驱动
  case Result of
    pkBitmap: Graphic := TBitmap.Create;
    pkMetafile: Graphic := TMetafile.Create;
    pkIcon: Graphic := TIcon.Create;
    pkJPEG: Graphic := TJPEGImage.Create;
  end;
  Picture.Graphic := Graphic;
  if Graphic <> nil then
  begin
    Graphic.Free;
    Picture.Graphic.LoadFromStream(Stream);
  end;
end;

//将图像的属性写入Offset 0 位，长一个字节。文件长写入 Offset 1，长四个字节。
function TLSImg.SaveToStream(Stream: TMemoryStream): byte;
var
  n, o: Integer;
begin
  Result := pkNone;
  //确定图像的属性
  if Picture.Graphic <> nil then
    if Picture.Graphic is TBitmap then
      Result := pkBitmap
    else if Picture.Graphic is TMetafile then
      Result := pkMetafile
    else if Picture.Graphic is TIcon then
      Result := pkIcon
    else if Picture.Graphic is TJPEGImage then
      Result := pkJPEG;
  Stream.Seek(0, soFromBeginning);
  //在 Offset 0位置上写入图像属性，字长1 Byte。
  Stream.Write(Result, 1);
  n := Stream.Position;
  Stream.Write(n, 4);
  if Result <> pkNone then
    Picture.Graphic.SaveToStream(Stream);
  o := Stream.Position;
  Stream.Seek(n, soFromBeginning);
  //在 Offset 1位置上写入图像的长度，字长 4 Byte。
  Stream.Write(o, 4);
  Stream.Seek(0, soFromBeginning);
end;

end.
 