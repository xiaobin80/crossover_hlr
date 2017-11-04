unit uLoadSaveImg;

interface
uses
  SysUtils, Classes, Graphics, Jpeg, DB, ADODB;

//�����ͼ������˳�������ⰲ�ŵģ��������޸ģ����ڵ�˳���FastReport��ͬ����FastReport�д�ӡͼ��//ʱ���÷��ص�ͼ���������� FastReport ��Picture ����� BlobType��
//procedure TForm1.frReportBeforePrint(Memo: TStringList; View: TfrView);
//begin
//��if (View is TfrPictureView) and ((View as TfrPictureView).Name = ��Picture1��) then
//��begin
//����(View as TfrPictureView).BlobType := LSImg.LoadFromStream(Stream);
//����(View as TfrPictureView).Picture.Assign(LSImg.Picture1.Picture);
//��end;
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

//����������ļ����͵�����Ӧ����������

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

//���ļ�ͷ��ͼ������࣬Ȼ�������Ӧ�������������ļ�������ʱû��ʹ��
function TLSImg.LoadFromStream(Stream: TMemoryStream): byte;
var
  n: Integer;
begin
  Stream.Seek(0, soFromBeginning);
  //���ļ�����
  Stream.Read(Result, 1);
  //���ļ���
  Stream.Read(n, 4);
  Graphic := nil;
  //������Ӧ������
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

//��ͼ�������д��Offset 0 λ����һ���ֽڡ��ļ���д�� Offset 1�����ĸ��ֽڡ�
function TLSImg.SaveToStream(Stream: TMemoryStream): byte;
var
  n, o: Integer;
begin
  Result := pkNone;
  //ȷ��ͼ�������
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
  //�� Offset 0λ����д��ͼ�����ԣ��ֳ�1 Byte��
  Stream.Write(Result, 1);
  n := Stream.Position;
  Stream.Write(n, 4);
  if Result <> pkNone then
    Picture.Graphic.SaveToStream(Stream);
  o := Stream.Position;
  Stream.Seek(n, soFromBeginning);
  //�� Offset 1λ����д��ͼ��ĳ��ȣ��ֳ� 4 Byte��
  Stream.Write(o, 4);
  Stream.Seek(0, soFromBeginning);
end;

end.
 