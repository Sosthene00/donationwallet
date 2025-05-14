use std::{
    collections::{HashMap, HashSet},
    mem,
};

use sp_client::{
    bitcoin::{absolute::Height, BlockHash, OutPoint},
    OwnedOutput, Updater
};

use anyhow::Result;

#[derive(Debug)]
pub enum StateUpdate {
    NoUpdate {
        blkheight: Height,
    },
    Update {
        blkheight: Height,
        blkhash: BlockHash,
        found_outputs: HashMap<OutPoint, OwnedOutput>,
        found_inputs: HashSet<OutPoint>,
    },
}

pub struct StateUpdater {
    update: bool,
    blkhash: Option<BlockHash>,
    blkheight: Option<Height>,
    found_outputs: HashMap<OutPoint, OwnedOutput>,
    found_inputs: HashSet<OutPoint>,
}

impl StateUpdater {
    pub fn new() -> Self {
        Self {
            update: false,
            blkheight: None,
            blkhash: None,
            found_outputs: HashMap::new(),
            found_inputs: HashSet::new(),
        }
    }

    pub fn to_update(&mut self) -> Result<StateUpdate> {
        let blkheight = self
            .blkheight
            .ok_or(anyhow::Error::msg("blkheight not filled"))?;

        if self.update {
            self.update = false;

            let blkhash = self.blkhash.ok_or(anyhow::Error::msg("blkhash not set"))?;

            self.blkheight = None;
            self.blkhash = None;

            // take results, and insert new empty values
            let found_inputs = mem::take(&mut self.found_inputs);
            let found_outputs = mem::take(&mut self.found_outputs);

            Ok(StateUpdate::Update {
                blkheight,
                blkhash,
                found_outputs,
                found_inputs,
            })
        } else {
            Ok(StateUpdate::NoUpdate { blkheight })
        }
    }
}
