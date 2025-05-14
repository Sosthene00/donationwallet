use std::{
    collections::{HashMap, HashSet}
};

use dana_core::state::StateUpdater;
use dana_core::sp_client::{
    bitcoin::{absolute::Height, BlockHash, OutPoint},
    OwnedOutput, Updater,
};

use crate::stream::{send_scan_progress, send_state_update, ScanProgress};

use dana_core::anyhow::Result;

pub struct FrbUpdater {
    inner: StateUpdater,
}

impl FrbUpdater {
    pub fn new() -> Self {
        FrbUpdater { inner: StateUpdater::new() }
    }
}

impl Updater for FrbUpdater {
    fn record_scan_progress(
        &mut self,
        start: Height,
        current: Height,
        end: Height
    ) -> Result<()> {
        // 1) update the pure‐Rust state
        self.inner.record_scan_progress(start, current, end)?;

        // 2) push the FRB event
        send_scan_progress(ScanProgress {
            start: start.to_consensus_u32(),
            current: current.to_consensus_u32(),
            end:   end.to_consensus_u32(),
        });

        Ok(())
    }

    fn record_block_outputs(
        &mut self,
        height: Height,
        blkhash: BlockHash,
        found_outputs: HashMap<OutPoint, OwnedOutput>,
    ) -> Result<()> {
        // may have already been written by record_block_inputs
        self.update = true;
        self.found_outputs = found_outputs;
        self.blkhash = Some(blkhash);
        self.blkheight = Some(height);

        Ok(())
    }

    fn record_block_inputs(
        &mut self,
        blkheight: Height,
        blkhash: BlockHash,
        found_inputs: HashSet<OutPoint>,
    ) -> Result<()> {
        self.update = true;
        self.blkheight = Some(blkheight);
        self.blkhash = Some(blkhash);
        self.found_inputs = found_inputs;

        Ok(())
    }

    fn save_to_persistent_storage(&mut self) -> Result<()> {
        send_state_update(self.to_update()?);
        Ok(())
    }
}