const weaponsData = {
    weapons: [
        { code: '0', label: 'Empty', type: 'Weapon', tl: 7, mcr: 0, rangeSpec: 'space' },
        { code: 'A', label: 'Particle Accelerator', type: 'Weapon', tl: 11, mcr: 2.5, rangeSpec: 'space' },
        { code: 'B', label: 'Slug Thrower', type: 'Weapon', tl: 9, mcr: 0.2, rangeSpec: 'world' },
        { code: 'D', label: 'DataCaster', type: 'Weapon', tl: 10, mcr: 1, rangeSpec: 'world' },
        { code: 'E', label: 'Stasis', type: 'Weapon', tl: 21, mcr: 5, rangeSpec: 'world' },
    ],
    mounts: [
        { code: 'T1',    label: 'Single Turret',            mountTons: 1,    mod: -2,  mountMcr: 0.2  },
        { code: 'T1de',  label: 'Single Turret Deployable', mountTons: 3,    mod: -2,  mountMcr: 3.2  },
        { code: 'T2'   , label: 'Dual Turret',              mountTons: 1,    mod: -1,  mountMcr: 0.5  },
        { code: 'T2de' , label: 'Dual Turret Deployable',   mountTons: 3,    mod: -1,  mountMcr: 3.5  },
        { code: 'T3'   , label: 'Triple Turret',            mountTons: 1,    mod: 0,   mountMcr: 1.0  },
        { code: 'T3de' , label: 'Triple Turret Deployable', mountTons: 3,    mod: 0,   mountMcr: 4.0  },
        { code: 'T4'   , label: 'Quad Turret',              mountTons: 1,    mod: 1,   mountMcr: 1.5  },
        { code: 'T4de' , label: 'Quad Turret Deployable',   mountTons: 3,    mod: 1,   mountMcr: 4.5  },
        { code: 'B1'   , label: 'Barbette',                 mountTons: 3,    mod: 2,   mountMcr: 3    },
        { code: 'B1de' , label: 'Barbette Deployable',      mountTons: 5,    mod: 2,   mountMcr: 6    },
        { code: 'B2'   , label: 'Dual Barbette',            mountTons: 5,    mod: 3,   mountMcr: 4    },
        { code: 'B2de' , label: 'Dual Barbette Deployable', mountTons: 7,    mod: 3,   mountMcr: 7    },
        { code: 'Bay'  , label: 'Bay',                      mountTons: 50,   mod: 5,   mountMcr: 5    },
        { code: 'LBay' , label: 'LBay',                     mountTons: 100,  mod: 8,   mountMcr: 10   },
        { code: 'M'    , label: 'Main',                     mountTons: 200,  mod: 10,  mountMcr: 20   },
    ]
};
