angular
.module('webui.services.configuration',  [])
.constant('$name', 'Aria2 WebUI')
.constant('$titlePattern', 'DL: {download_speed} - UL: {upload_speed}')
.constant('$pageSize', 11)
.constant('$authconf', {
  host: '192.168.123.1',
  path: '/jsonrpc',
  port: '6800',
  encrypt: false,
  auth: {
  //token: 'admin',
  user: 'VoxHuang',
  pass: 'hjw543210',
  },
  directURL: ''
})
.constant('$enable', {
  torrent: true,
  metalink: true,
  sidebar: {
    show: true,
    stats: true,
    filters: true,
    starredProps: true,
  }
})
.constant('$starredProps', [
  'dir', 'auto-file-renaming', 'max-connection-per-server'
])
.constant('$downloadProps', [
  'pause', 'dir', 'max-connection-per-server'
])
.constant('$globalTimeout', 1000)
;

