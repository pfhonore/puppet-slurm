# GPU detection
gpus = Dir.glob("/dev/nvidia[0-99]")
if gpus.length >= 1
	gpu_node = "true"
	gpu_count = gpus.length

  Facter.add("gpu_count") do
		setcode do
			gpu_count
		end
	end
	Facter.add("gpus") do
		setcode do
			gpus.join(",")
		end
	end
else
	gpu_node="false"
end

Facter.add("gpu_node") do
	setcode do
		gpu_node
	end
end
