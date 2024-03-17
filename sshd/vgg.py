import argparse
import torch
import torch.nn as nn
import time
import os
os.environ['CUDA_LAUNCH_BLOCKING'] = "1"

parser = argparse.ArgumentParser(description='GPU Memory Occupation Script')
parser.add_argument('--mem_size', type=int, default=256, help='Size of tensor to allocate memory (will be squared)')
parser.add_argument('--duration', type=int, default=24, help='Duration to run the program, in hours')
args = parser.parse_args()

device = torch.device('cuda')

class SmallModel(nn.Module):
    def __init__(self):
        super(SmallModel, self).__init__()
        self.linear = nn.Linear(args.mem_size, args.mem_size)

    def forward(self, x):
        return self.linear(x)

model = SmallModel().to(device)

input_data = torch.randn(args.mem_size, args.mem_size).to(device)

model.train()

optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

end_time = time.time() + args.duration * 3600  # 转换小时为秒
print(f'Running with memory size: {args.mem_size}x{args.mem_size}, duration: {args.duration} hours')

while time.time() < end_time:
    output = model(input_data)

    loss = output.sum()

    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    time.sleep(0.1)


print('Finished running.')
