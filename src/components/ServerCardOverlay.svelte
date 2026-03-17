<script lang="ts">
    export let reason: string = "OFFLINE";
</script>

<div class="relative group overflow-hidden rounded-lg border border-border bg-card">
    
    <div class="opacity-40 grayscale-[0.8] pointer-events-none select-none">
        <slot />
    </div>

    <div 
        class="absolute z-10 pointer-events-none"
        style="
            top: 1px; left: 1px; width: calc(100% - 2px); height: calc(100% - 2px);
            border-radius: 7px;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            -webkit-mask-image: radial-gradient(circle, rgba(0,0,0,0) 0%, rgba(0,0,0,0.6) 70%, rgba(0,0,0,1) 100%);
            mask-image: radial-gradient(circle, rgba(0,0,0,0) 0%, rgba(0,0,0,0.6) 70%, rgba(0,0,0,1) 100%);
        "
    ></div>

    <div class="absolute inset-0 z-20 flex items-center justify-center cursor-not-allowed">
        <div class="transform scale-110">
            <span class="text-xs font-black tracking-[0.25em] text-primary uppercase">
                {reason}
            </span>
        </div>
    </div>
</div>