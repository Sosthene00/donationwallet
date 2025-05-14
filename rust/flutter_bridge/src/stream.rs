use std::{
    collections::{HashMap, HashSet},
    sync::Mutex,
};

use dana_core::lazy_static::lazy_static;
use dana_core::sp_client::{
    bitcoin::{absolute::Height, BlockHash, OutPoint},
    OwnedOutput,
};
use dana_core::state::updater::StateUpdate;

use crate::frb_generated::StreamSink;

lazy_static! {
    static ref SCAN_PROGRESS_STREAM_SINK: Mutex<Option<StreamSink<ScanProgress>>> =
        Mutex::new(None);
    static ref STATE_UPDATE_STREAM_SINK: Mutex<Option<StreamSink<ApiStateUpdate>>> = Mutex::new(None);
}

pub struct ScanProgress {
    pub start: u32,
    pub current: u32,
    pub end: u32,
}

pub struct ApiStateUpdate(StateUpdate);

pub fn create_scan_progress_stream(s: StreamSink<ScanProgress>) {
    let mut stream_sink = SCAN_PROGRESS_STREAM_SINK.lock().unwrap();
    *stream_sink = Some(s);
}

pub fn create_scan_update_stream(s: StreamSink<ApiStateUpdate>) {
    let mut stream_sink = STATE_UPDATE_STREAM_SINK.lock().unwrap();
    *stream_sink = Some(s);
}

pub(crate) fn send_scan_progress(scan_progress: ScanProgress) {
    let stream_sink = SCAN_PROGRESS_STREAM_SINK.lock().unwrap();
    if let Some(stream_sink) = stream_sink.as_ref() {
        stream_sink.add(scan_progress).unwrap();
    }
}

pub(crate) fn send_state_update(update: ApiStateUpdate) {
    let stream_sink = STATE_UPDATE_STREAM_SINK.lock().unwrap();
    if let Some(stream_sink) = stream_sink.as_ref() {
        stream_sink.add(update).unwrap();
    }
}
