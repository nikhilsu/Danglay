# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SamlController, type: :controller do
  valid_response = 'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c2FtbDJwOlJlc3BvbnNlIHhtbG5zOnNhbWwycD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sIiBEZXN0aW5hdGlvbj0iaHR0cDovL2xvY2FsaG9zdDozMDAwL3NhbWwvY29uc3VtZSIgSUQ9ImlkMTYzMDYxNDc2ODU5MDQyMDcxNDAwNzMyMjI4IiBJblJlc3BvbnNlVG89Il9hYzIzYzM2MC03NjYxLTAxMzMtZDZkNy0yOGNmZTkyMGE3YWYiIElzc3VlSW5zdGFudD0iMjAxNS0xMS0yNlQxMTo0OTo0OS4wMjBaIiBWZXJzaW9uPSIyLjAiIHhtbG5zOnhzPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYSI+PHNhbWwyOklzc3VlciB4bWxuczpzYW1sMj0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiIgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6bmFtZWlkLWZvcm1hdDplbnRpdHkiPmh0dHA6Ly93d3cub2t0YS5jb20vZXhrNWZuOTB6aWszUmRwUzMwaDc8L3NhbWwyOklzc3Vlcj48ZHM6U2lnbmF0dXJlIHhtbG5zOmRzPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48ZHM6U2lnbmVkSW5mbz48ZHM6Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPjxkczpTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNyc2Etc2hhMjU2Ii8+PGRzOlJlZmVyZW5jZSBVUkk9IiNpZDE2MzA2MTQ3Njg1OTA0MjA3MTQwMDczMjIyOCI+PGRzOlRyYW5zZm9ybXM+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIi8+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyI+PGVjOkluY2x1c2l2ZU5hbWVzcGFjZXMgeG1sbnM6ZWM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIgUHJlZml4TGlzdD0ieHMiLz48L2RzOlRyYW5zZm9ybT48L2RzOlRyYW5zZm9ybXM+PGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxkczpEaWdlc3RWYWx1ZT5NSTMwU3hXYndzUWllczBqUSs1YmVHSFBSSloxMS9PR2RVKytYRy83RmMwPTwvZHM6RGlnZXN0VmFsdWU+PC9kczpSZWZlcmVuY2U+PC9kczpTaWduZWRJbmZvPjxkczpTaWduYXR1cmVWYWx1ZT54Y2tLMHU4MXBQS3V2VkhVVElVS0pXSms2dEc2WHQzcFczSVpoT2JjZGlQMGlKMGVETFNyMEU5Sy9DTTR6MjNKMERKQjduOHh5M21GOGI1ZVUzYjZXUWV3dmNjNy9ZN29uLzdIWkRER0J5N0tJRytTdDlJRVRNUkdBbDIrcDhnSVJ6c3kzQ3RVZVkyYnluQWZUczJjeDJNbFhPZmJkbUFzcy95dXROZklvVmlMZjlPcW90NGV5NzNsNzVwVzJaVHJnV2NNSXl1elpGa1l0cVU1SkJJa0ExQVhHSGlFM3BRYStYbU5meXp2YTFFT2VlYzhoUXJxdGpVS2k2eXFJQ1ptS1RWUngzRnNlQ1B2S3IwRmZpRXl1bVVoQktZNXM5TTZoUXQzdXB6dXhPR0hHZjlIWFVqUGI5SlNiTFVDVEcyeG5pdFI5QWdCV1pvMnFUVVlrZ0Z5Nmc9PTwvZHM6U2lnbmF0dXJlVmFsdWU+PGRzOktleUluZm8+PGRzOlg1MDlEYXRhPjxkczpYNTA5Q2VydGlmaWNhdGU+TUlJRHBEQ0NBb3lnQXdJQkFnSUdBVkU1L2w3NU1BMEdDU3FHU0liM0RRRUJCUVVBTUlHU01Rc3dDUVlEVlFRR0V3SlZVekVUTUJFRwpBMVVFQ0F3S1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ3d05VMkZ1SUVaeVlXNWphWE5qYnpFTk1Bc0dBMVVFQ2d3RVQydDBZVEVVCk1CSUdBMVVFQ3d3TFUxTlBVSEp2ZG1sa1pYSXhFekFSQmdOVkJBTU1DbVJsZGkwM056UTJPVFF4SERBYUJna3Foa2lHOXcwQkNRRVcKRFdsdVptOUFiMnQwWVM1amIyMHdIaGNOTVRVeE1USTBNVFExTkRVd1doY05NalV4TVRJME1UUTFOVFV3V2pDQmtqRUxNQWtHQTFVRQpCaE1DVlZNeEV6QVJCZ05WQkFnTUNrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY01EVk5oYmlCR2NtRnVZMmx6WTI4eERUQUxCZ05WCkJBb01CRTlyZEdFeEZEQVNCZ05WQkFzTUMxTlRUMUJ5YjNacFpHVnlNUk13RVFZRFZRUUREQXBrWlhZdE56YzBOamswTVJ3d0dnWUoKS29aSWh2Y05BUWtCRmcxcGJtWnZRRzlyZEdFdVkyOXRNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQQo4cW93Z3kyTzBXMFc2V1ZQRXFUeGVUQ0svdW5ZTHU0NldZSWgvbU5LeUhFcHpUQ25nMWV1MElFMXBWaXFoVmk3dWhKNDNDU2JRWEZhClRBMGNqZUlmMUkvNmhVaitlWWROeVNMWWhES2ErbS9WVzNrajROTXBDQzRQT1RZT1pWTWtDOWRNOFY5eXNqcEM1V2xJVzhhdnVocVoKWFZsVmJGM0liaitpc05xelV1NDQzTFdoNzVaL3dRODhsK3piNWtoNmNtMXpEcHcwUFplQzg5bjJobXF3RkpVb013UHRIS1B5ekFGQgpkYm0yUjVoRmNWNk5Ma1RoRTVRNUYvSEl0N3FsWnc3bC9JUlNRSHlrZW9JdlZHQWZSc3JUbkJWbytVVUw0V0dnWUdWd29OYjNxTEZzCnE0OStCTnlGdFJoSG9jL0pxenF1ZzNQb1k2dmJqb0NxdkVzbmlRSURBUUFCTUEwR0NTcUdTSWIzRFFFQkJRVUFBNElCQVFEbStYejMKSExpVXdKSDR0U0VkenhhZnJIMHV3d2xqcHRxeUxpTkl6RmwyQ2lySEVyT2VyeXZkZWdudTljVXR2YWRMN1ZXU0J0SG8wYm1EQUd3WApraTJvcVRVclhEdHAwTjJ2Q0pMUTE5TUN0UEdETU11ZmJSaFczZS91b0tFTG1KUFBQdXZBblE5aDUwbmFXUks0ZDZFODBSZVl2clhhCk5reFJHeXYzMzZnZWo0b2U4d3VDY2F3ZjBvTitZVVpvVURnOVE1NytqNk1kNE9XR09RL2QzMjhiOEFLbHJrekpqMjZ6eW9BWkZMa2oKZ3l6YlVHNERGeXMwamY1SEFwNnBWVkFjZUtHd1IrRERkWEZVK3Zib0hkdUNHb2FVaEFNRFVRR215RDBKUmdrcW1pa2FGK3NpLzNBQgovNitvbUNLcmNOSTNaemRleDhmb2tSZFAxN0gyMVFMajwvZHM6WDUwOUNlcnRpZmljYXRlPjwvZHM6WDUwOURhdGE+PC9kczpLZXlJbmZvPjwvZHM6U2lnbmF0dXJlPjxzYW1sMnA6U3RhdHVzIHhtbG5zOnNhbWwycD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sIj48c2FtbDJwOlN0YXR1c0NvZGUgVmFsdWU9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpzdGF0dXM6U3VjY2VzcyIvPjwvc2FtbDJwOlN0YXR1cz48c2FtbDI6QXNzZXJ0aW9uIHhtbG5zOnNhbWwyPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uIiBJRD0iaWQxNjMwNjE0NzY4NjAwOTYwNDYzODk3NjI2MiIgSXNzdWVJbnN0YW50PSIyMDE1LTExLTI2VDExOjQ5OjQ5LjAyMFoiIFZlcnNpb249IjIuMCIgeG1sbnM6eHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hIj48c2FtbDI6SXNzdWVyIEZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOm5hbWVpZC1mb3JtYXQ6ZW50aXR5IiB4bWxuczpzYW1sMj0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiI+aHR0cDovL3d3dy5va3RhLmNvbS9leGs1Zm45MHppazNSZHBTMzBoNzwvc2FtbDI6SXNzdWVyPjxkczpTaWduYXR1cmUgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxkczpTaWduZWRJbmZvPjxkczpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PGRzOlNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48ZHM6UmVmZXJlbmNlIFVSST0iI2lkMTYzMDYxNDc2ODYwMDk2MDQ2Mzg5NzYyNjIiPjxkczpUcmFuc2Zvcm1zPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiPjxlYzpJbmNsdXNpdmVOYW1lc3BhY2VzIHhtbG5zOmVjPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiIFByZWZpeExpc3Q9InhzIi8+PC9kczpUcmFuc2Zvcm0+PC9kczpUcmFuc2Zvcm1zPjxkczpEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48ZHM6RGlnZXN0VmFsdWU+dGtEM0ZDRU5hSWhrVXpIOFRueUVzeEdkWVpjYmw2anBGY0ZOcjM0elc5UT08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+bGpQUlZRaUI3VzlydkN0Qkh3c1FpMFB3cUg3UEhYbWpZVm0xMDBWZzZxRnRxSU9xSWREWEZTejdzWmNuSzRLU21rS2VmeFVSV3RQUlZ3ZmFhSWVKVmJ5U0J2Z002dU9KbzJENWZ1MkhrU0syU0lOSTBJajl2QWZFSDR1L2RaSzZUSDBkUlJoZlYwVXlIemNGajZDWFVIWEVnZFVYSHMzbmVXYzAyNXExV3N4cEJOd0poTVR6b3VhbmxadVl4TVNyN1dHd0RkRW1WWVN5MjJKWkFzM1M4OXVDNGszYkV2TTQ4ZkFPcFQ5NGtQWDkvSWZ0RkFYU0VKM3lrQXM0QmVNdU9CYjl1eG9KVHIyVXlQZEdTSm44SWxwM0RoNndFeUI1QTNtYllCdWdpc0RBZzdMejlmaVF4U2pGTnBaR1N6eW5YVFkwdGtIRUgzdjFRT0dYaE9Bd2hRPT08L2RzOlNpZ25hdHVyZVZhbHVlPjxkczpLZXlJbmZvPjxkczpYNTA5RGF0YT48ZHM6WDUwOUNlcnRpZmljYXRlPk1JSURwRENDQW95Z0F3SUJBZ0lHQVZFNS9sNzVNQTBHQ1NxR1NJYjNEUUVCQlFVQU1JR1NNUXN3Q1FZRFZRUUdFd0pWVXpFVE1CRUcKQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVXTUJRR0ExVUVCd3dOVTJGdUlFWnlZVzVqYVhOamJ6RU5NQXNHQTFVRUNnd0VUMnQwWVRFVQpNQklHQTFVRUN3d0xVMU5QVUhKdmRtbGtaWEl4RXpBUkJnTlZCQU1NQ21SbGRpMDNOelEyT1RReEhEQWFCZ2txaGtpRzl3MEJDUUVXCkRXbHVabTlBYjJ0MFlTNWpiMjB3SGhjTk1UVXhNVEkwTVRRMU5EVXdXaGNOTWpVeE1USTBNVFExTlRVd1dqQ0JrakVMTUFrR0ExVUUKQmhNQ1ZWTXhFekFSQmdOVkJBZ01Da05oYkdsbWIzSnVhV0V4RmpBVUJnTlZCQWNNRFZOaGJpQkdjbUZ1WTJselkyOHhEVEFMQmdOVgpCQW9NQkU5cmRHRXhGREFTQmdOVkJBc01DMU5UVDFCeWIzWnBaR1Z5TVJNd0VRWURWUVFEREFwa1pYWXROemMwTmprME1Sd3dHZ1lKCktvWklodmNOQVFrQkZnMXBibVp2UUc5cmRHRXVZMjl0TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEKOHFvd2d5Mk8wVzBXNldWUEVxVHhlVENLL3VuWUx1NDZXWUloL21OS3lIRXB6VENuZzFldTBJRTFwVmlxaFZpN3VoSjQzQ1NiUVhGYQpUQTBjamVJZjFJLzZoVWorZVlkTnlTTFloREthK20vVlcza2o0Tk1wQ0M0UE9UWU9aVk1rQzlkTThWOXlzanBDNVdsSVc4YXZ1aHFaClhWbFZiRjNJYmoraXNOcXpVdTQ0M0xXaDc1Wi93UTg4bCt6YjVraDZjbTF6RHB3MFBaZUM4OW4yaG1xd0ZKVW9Nd1B0SEtQeXpBRkIKZGJtMlI1aEZjVjZOTGtUaEU1UTVGL0hJdDdxbFp3N2wvSVJTUUh5a2VvSXZWR0FmUnNyVG5CVm8rVVVMNFdHZ1lHVndvTmIzcUxGcwpxNDkrQk55RnRSaEhvYy9KcXpxdWczUG9ZNnZiam9DcXZFc25pUUlEQVFBQk1BMEdDU3FHU0liM0RRRUJCUVVBQTRJQkFRRG0rWHozCkhMaVV3Skg0dFNFZHp4YWZySDB1d3dsanB0cXlMaU5JekZsMkNpckhFck9lcnl2ZGVnbnU5Y1V0dmFkTDdWV1NCdEhvMGJtREFHd1gKa2kyb3FUVXJYRHRwME4ydkNKTFExOU1DdFBHRE1NdWZiUmhXM2UvdW9LRUxtSlBQUHV2QW5ROWg1MG5hV1JLNGQ2RTgwUmVZdnJYYQpOa3hSR3l2MzM2Z2VqNG9lOHd1Q2Nhd2Ywb04rWVVab1VEZzlRNTcrajZNZDRPV0dPUS9kMzI4YjhBS2xya3pKajI2enlvQVpGTGtqCmd5emJVRzRERnlzMGpmNUhBcDZwVlZBY2VLR3dSK0REZFhGVSt2Ym9IZHVDR29hVWhBTURVUUdteUQwSlJna3FtaWthRitzaS8zQUIKLzYrb21DS3JjTkkzWnpkZXg4Zm9rUmRQMTdIMjFRTGo8L2RzOlg1MDlDZXJ0aWZpY2F0ZT48L2RzOlg1MDlEYXRhPjwvZHM6S2V5SW5mbz48L2RzOlNpZ25hdHVyZT48c2FtbDI6U3ViamVjdCB4bWxuczpzYW1sMj0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiI+PHNhbWwyOk5hbWVJRCBGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMTpuYW1laWQtZm9ybWF0OnVuc3BlY2lmaWVkIj50aGVqYXNiQHRob3VnaHR3b3Jrcy5jb208L3NhbWwyOk5hbWVJRD48c2FtbDI6U3ViamVjdENvbmZpcm1hdGlvbiBNZXRob2Q9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpjbTpiZWFyZXIiPjxzYW1sMjpTdWJqZWN0Q29uZmlybWF0aW9uRGF0YSBJblJlc3BvbnNlVG89Il9hYzIzYzM2MC03NjYxLTAxMzMtZDZkNy0yOGNmZTkyMGE3YWYiIE5vdE9uT3JBZnRlcj0iMjAxNS0xMS0yNlQxMTo1NDo0OS4wMjBaIiBSZWNpcGllbnQ9Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMC9zYW1sL2NvbnN1bWUiLz48L3NhbWwyOlN1YmplY3RDb25maXJtYXRpb24+PC9zYW1sMjpTdWJqZWN0PjxzYW1sMjpDb25kaXRpb25zIE5vdEJlZm9yZT0iMjAxNS0xMS0yNlQxMTo0NDo0OS4wMjBaIiBOb3RPbk9yQWZ0ZXI9IjIwMTUtMTEtMjZUMTE6NTQ6NDkuMDIwWiIgeG1sbnM6c2FtbDI9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphc3NlcnRpb24iPjxzYW1sMjpBdWRpZW5jZVJlc3RyaWN0aW9uPjxzYW1sMjpBdWRpZW5jZT50aGVkYW5nbGF5Zm9sbG93ZXJzPC9zYW1sMjpBdWRpZW5jZT48L3NhbWwyOkF1ZGllbmNlUmVzdHJpY3Rpb24+PC9zYW1sMjpDb25kaXRpb25zPjxzYW1sMjpBdXRoblN0YXRlbWVudCBBdXRobkluc3RhbnQ9IjIwMTUtMTEtMjZUMTE6NDk6NDkuMDIwWiIgU2Vzc2lvbkluZGV4PSJfYWMyM2MzNjAtNzY2MS0wMTMzLWQ2ZDctMjhjZmU5MjBhN2FmIiB4bWxuczpzYW1sMj0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiI+PHNhbWwyOkF1dGhuQ29udGV4dD48c2FtbDI6QXV0aG5Db250ZXh0Q2xhc3NSZWY+dXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFjOmNsYXNzZXM6UGFzc3dvcmRQcm90ZWN0ZWRUcmFuc3BvcnQ8L3NhbWwyOkF1dGhuQ29udGV4dENsYXNzUmVmPjwvc2FtbDI6QXV0aG5Db250ZXh0Pjwvc2FtbDI6QXV0aG5TdGF0ZW1lbnQ+PHNhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudCB4bWxuczpzYW1sMj0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiI+PHNhbWwyOkF0dHJpYnV0ZSBOYW1lPSJGaXJzdE5hbWUiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6YmFzaWMiPjxzYW1sMjpBdHRyaWJ1dGVWYWx1ZSB4bWxuczp4cz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEiIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTp0eXBlPSJ4czpzdHJpbmciPnRoZWphczwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBOYW1lPSJMYXN0TmFtZSIgTmFtZUZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmF0dHJuYW1lLWZvcm1hdDpiYXNpYyI+PHNhbWwyOkF0dHJpYnV0ZVZhbHVlIHhtbG5zOnhzPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYSIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9InhzOnN0cmluZyI+YmFidTwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBOYW1lPSJFbWFpbCIgTmFtZUZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmF0dHJuYW1lLWZvcm1hdDpiYXNpYyI+PHNhbWwyOkF0dHJpYnV0ZVZhbHVlIHhtbG5zOnhzPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYSIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9InhzOnN0cmluZyI+dGhlamFzYkB0aG91Z2h0d29ya3MuY29tPC9zYW1sMjpBdHRyaWJ1dGVWYWx1ZT48L3NhbWwyOkF0dHJpYnV0ZT48L3NhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudD48L3NhbWwyOkFzc2VydGlvbj48L3NhbWwycDpSZXNwb25zZT4='

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  it 'init should redirect to okta login' do
    get :init
    expect(response.body).to include 'redirected'
    expect(response.location).to include 'https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml'
  end

  it 'consume should parse valid saml response' do
    stub_response = OneLogin::RubySaml::Response.new(valid_response)

    allow(OneLogin::RubySaml::Response).to receive(:new).and_return(stub_response)

    allow(stub_response).to receive(:is_valid?).and_return(true)

    post :consume

    expect(stub_response.name_id).to be_truthy
    expect(stub_response.attributes).to be_truthy
    expect(response).to redirect_to root_url
  end

  it 'consume should parse valid saml response if admin should redirect to admin home' do
    stub_response = OneLogin::RubySaml::Response.new(valid_response)

    allow(OneLogin::RubySaml::Response).to receive(:new).and_return(stub_response)

    allow(stub_response).to receive(:is_valid?).and_return(true)

    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    role = build_stubbed(:role, :admin_role)
    user.role = role
    allow(User).to receive(:find_by).and_return(user)

    post :consume

    expect(stub_response.name_id).to be_truthy
    expect(stub_response.attributes).to be_truthy
    expect(response).to redirect_to admin_url
  end

  it 'consume should parse valid saml response with friendly forwarding' do
    stub_response = OneLogin::RubySaml::Response.new(valid_response)

    session[:forward_url] = 'host.com' if session[:forward_url].nil?

    allow(OneLogin::RubySaml::Response).to receive(:new).and_return(stub_response)

    allow(stub_response).to receive(:is_valid?).and_return(true)

    post :consume

    expect(stub_response.name_id).to be_truthy
    expect(stub_response.attributes).to be_truthy
    expect(response).to redirect_to 'host.com'
    session.clear
  end

  it 'consume should redirect to okta page on invalid saml response' do
    stub_response = OneLogin::RubySaml::Response.new(valid_response)
    allow(OneLogin::RubySaml::Response).to receive(:new).and_return(stub_response)
    allow(stub_response).to receive(:is_valid?).and_return(false)

    post :consume

    expect(response.location).to include 'https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml'
  end
end
